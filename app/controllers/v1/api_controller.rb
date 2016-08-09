require_relative '../application_controller'

module Controllers
  module V1
    class ApiController < ApplicationController
      respond_to :json

      before_action :doorkeeper_authorize!

      def index
        options = {}

        if params[:include].present?
          options[:include] = params[:include].split(',').map(&:to_sym)
        end

        render(json: list(params).map { |r| r.as_json(options) })
      end

      def create
        resource = self.class.model_class.create(params)

        not_valid! unless resource.valid?

        resource.save!

        render(json: resource.as_json, status: 201)
      rescue ValidationError => e
        halt(401, e.errors.to_json)
      end

      def show
        resource = self.class.model_class.find(params[:id])

        raise PermissionError, :read unless resource.readable_by?(current_user)

        render(json: resource.as_json)
      rescue ActiveRecord::RecordNotFound => e
        not_found!(e.message)
      rescue PermissionError => e
        permission_error!(e.message)
      end

      def update
        resource = self.class.model_class.find(params[:id])

        raise PermissionError, :edit unless resource.editable_by?(current_user)

        resource.save!(params)

        render(json: resource.as_json)
      rescue ActiveRecord::RecordNotFound => e
        not_found!(e.message)
      rescue PermissionError => e
        permission_error!(e.message)
      end

      def destroy
        resource = self.class.model_class.find(params[:id])

        raise PermissionError, :delete unless resource.deletable_by?(current_user)

        resource.destroy!

        head :no_content
      rescue ActiveRecord::RecordNotFound => e
        not_found!(e.message)
      rescue PermissionError => e
        permission_error!(e.message)
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

      def list(params)
        self.class.model_class.accessible_to(current_user)
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

      def append_title_filter!(query, name)
        query.where!('name like ?', "%#{ params[:name] }%")
      end

      class << self
        attr_accessor :model_class
      end
    end
  end
end
