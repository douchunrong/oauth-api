require_relative '../../models/v1/attachment'
require_relative '../../models/v1/invite'
require_relative 'api_controller'

module Controllers
  module V1
    class UserInvitesController < ApiController
      ME_USER_ID = 'me'.freeze

      self.model_class = Models::V1::Invite
      self.resource_param = :invite

      protected

      def update_resource!(resource, params)
        raise PermissionError, :update unless actable?

        act_on_resource(resource, :accept)
      end

      def destroy_resource!(resource)
        raise PermissionError, :destroy unless actable?

        act_on_resource(resource, :reject)
      end

      private

      def user_id
        params[:user_id] == ME_USER_ID ? current_user_id : params[:user_id]
      end

      def actable?
        user_id == current_user_id || current_user.admin?
      end

      def act_on_resource(resource, action)
        resource.send(action, current_user_id)

        resource.save!

        resource
      end
    end
  end
end
