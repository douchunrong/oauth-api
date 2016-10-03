require_relative 'api_controller'

module Controllers
  module V1
    class UserResourceController < ApiController
      ME_USER_ID = 'me'.freeze

      def list_resources_base_query(params, includes = nil)
        raise NotImplementedError
      end

      protected

      def user_id
        return current_user_id if params[:user_id] == ME_USER_ID

        params[:user_id]
      end

      def user
        Models::V1::User.find(user_id)
      end

      def actable?
        user_id == current_user_id || current_user.admin?
      end
    end
  end
end
