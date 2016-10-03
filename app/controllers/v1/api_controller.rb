require_relative '../application_controller'
require_relative '../../service/v1/user_resource_view'

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

        resources = list_resources(params, includes)

        # ActiveRecords Serializers?
        if includes.include?(:locations)
          resources
            .select { |r| r.respond_to?(:locations) }
            .flat_map(&:locations)
            .each { |l| l.geocode!(request.location) }
        end

        render(json: resources.as_json(options))
      end

      def create
        resource = self.class.model_class.new(resource_params)
        resource.created_by = current_user

        not_valid! unless resource.valid?

        unless resource.createable_by?(current_user, resource_params)
          raise PermissionError, :create
        end

        resource.save!

        options = {
          include: permittable_read_includes(params[:id])
        }

        render \
          json: Service::V1::UserResourceView.factory(resource, current_user)
            .as_json(options),
          status: 201
      rescue ActionController::ParameterMissing => e
        validation_error!(e.message)
      rescue ActiveRecord::RecordInvalid => e
        halt(400, e.errors.to_json)
      end

      def show
        options = {}

        includes = options[:include] = permittable_read_includes(params[:id])

        resource = find(params[:id], includes)

        unless resource.readable_by?(current_user)
          raise PermissionError, :read
        end

        render \
          json: Service::V1::UserResourceView.factory(resource, current_user)
            .as_json(options)
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

        update_resource!(resource, resource_params)

        render \
          json: Service::V1::UserResourceView
            .factory(resource, current_user)
            .as_json
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

        destroy_resource!(resource)

        head :no_content
      rescue ActiveRecord::RecordNotFound => e
        not_found!(e.message)
      rescue PermissionError => e
        permission_error!(e.message)
      end

      protected

      def resource_params
        params
          .require(self.class.resource_param)
          .permit(self.class.model_class.column_names)
      end

      def permittable_list_includes
        []
      end

      def permittable_read_includes(resource_id)
        []
      end

      def list_resources(params, includes = nil)
        query = list_resources_base_query(params, includes)

        query.includes(includes) unless includes.nil?

        query.limit!(params[:limit] || 10)
        query.offset!(params[:offset] || 0)

        if params[:filter].present?
          query = append_list_filters!(query, params[:filter])
        end

        query
      end

      def list_resources_base_query(params, includes = nil)
        params[:admin] == 'true' && current_user.admin? ?
          self.class.model_class.all :
          self.class.model_class.accessible_to(current_user)
      end

      def find(id, includes = nil)
        self.class.model_class
          .tap { |c| c.includes(includes) unless includes.nil? }
          .find(params[:id])
      end

      def update_resource!(resource, params)
        resource.update_attributes(params)
      end

      def destroy_resource!(resource)
        resource.destroy!
      end

      def fail!(messages, status)
        render(json: { messages: messages }, status: status)
      end

      def not_found!(message)
        fail!(Array(message), 404)
      end

      def permission_error!(message)
        fail!(Array(message), 403)
      end

      def validation_error!(message)
        fail!(Array(message), 400)
      end

      # @todo: this feels dangerous. consider a stronger whitelist
      def append_list_filters!(query, filters)
        (self.class.model_class.columns & filters.keys)
          .select { |k| filters[k].present? }
          .each { |k| query.where!('#{ k } like ?', "%#{ filters[k] }%") }

        query
      end

      class << self
        attr_reader :model_class
        attr_accessor :resource_param

        def model_class=(klass)
          @model_class = klass

          # strips parameters that are not attributes of klass?
          wrap_parameters(klass)
        end
      end
    end
  end
end
