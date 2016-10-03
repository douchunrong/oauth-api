require_relative '../../models/v1/attachment'
require_relative '../../models/v1/invite'
require_relative 'user_resources_controller'

module Controllers
  module V1
    class UserInvitesController < UserResourceController
      self.model_class = Models::V1::Invite
      self.resource_param = :invite

      protected

      def update_resource!(invite, params)
        raise PermissionError, :update unless actable?

        act_on_invite(invite, :accept)
      end

      def destroy_resource!(invite)
        raise PermissionError, :destroy unless actable?

        act_on_invite(invite, :reject)
      end

      private

      def act_on_invite(invite, action)
        invite.send(action, current_user_id)
          .tap { |i| i.save! }
      end
    end
  end
end