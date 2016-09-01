require_relative '../application_controller'

module Controllers
  module V1
    class PermissionError < StandardError; end

    class ApiController < ApplicationController
      respond_to :json

      before_action :doorkeeper_authorize!
      skip_before_action :verify_authenticity_token

      def index
        options = {}

        includes = options[:include] = permittable_list_includes

        render(json: list(params, includes).as_json(options))
      end

      def create
        resource = self.class.model_class.new(resource_params)
        resource.created_by = current_user

        not_valid! unless resource.valid?

        unless resource.createable_by?(current_user, resource_params)
          raise PermissionError, :create
        end

        resource.save!

        render(json: resource.as_json, status: 201)
      rescue ActiveRecord::RecordInvalid => e
        halt(401, e.errors.to_json)
      end

      def show
        options = {}

        includes = options[:include] = permittable_read_includes(params[:id])

        resource = self.class.model_class
          .tap { |c| c.includes(includes) unless includes.nil? }
          .find(params[:id])

        unless resource.readable_by?(current_user)
          raise PermissionError, :read
        end

        render(json: resource.as_json(options))
      rescue ActiveRecord::RecordNotFound => e
        not_found!(e.message)
      rescue PermissionError => e
        permission_error!(e.message)
      end

      def update
        resource = self.class.model_class.find(params[:id])

        unless resource.updateable_by?(current_user, resource_params)
          raise PermissionError, :update
        end

        resource.update_attributes(resource_params)

        render(json: resource.as_json)
      rescue ActiveRecord::RecordNotFound => e
        not_found!(e.message)
      rescue ActiveModel::ForbiddenAttributesError => e
        validation_error!(e.message)
      rescue PermissionError => e
        permission_error!(e.message)
      end

      def destroy
        resource = self.class.model_class.find(params[:id])

        unless resource.deletable_by?(current_user)
          raise PermissionError, :delete
        end

        resource.destroy!

        head :no_content
      rescue ActiveRecord::RecordNotFound => e
        not_found!(e.message)
      rescue PermissionError => e
        permission_error!(e.message)
      end

      protected

      def resource_params
        params
          .require(:user)
          .permit(self.class.model_class.column_names)
      end

      def permittable_list_includes
        []
      end

      def permittable_read_includes(resource_id)
        []
      end

      def list(params, includes = nil)
        query = params[:admin] == 'true' && current_user.admin? ?
          self.class.model_class.all :
          self.class.model_class.accessible_to(current_user)

        query.includes(includes) unless includes.nil?

        query
          .tap do |query|
            query.limit!(params[:limit] || 10)
            query.offset!(params[:offset] || 0)

            if params[:include].present?
              query.includes!(params[:include].split(','))
            end

            if params[:name].present?
              append_title_filter!(query, params[:name])
            end
          end
      end

      private

      def fail!(messages, status)
        render(json: { messages: messages }, status: status)
      end

      def not_found!
        fail!([message], 404)
      end

      def permission_error!(message)
        fail!([message], 403)
      end

      def validation_error!(message)
        fail!([message], 400)
      end

      def append_title_filter!(query, name)
        query.where!('name like ?', "%#{ params[:name] }%")
      end

      class << self
        attr_reader :model_class

        def model_class=(klass)
          @model_class = klass

          # strips parameters that are not attributes of klass?
          wrap_parameters(klass)
        end
      end
    end
  end
end
