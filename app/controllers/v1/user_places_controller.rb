require_relative '../../models/v1/attachment'
require_relative '../../models/v1/invite'
require_relative 'user_resources_controller'

module Controllers
  module V1
    class UserPlacesController < UserResourceController
      self.model_class = Models::V1::Place
      self.resource_param = :place

      protected

      def list_resources_base_query(_params, _includes = nil)
        place_ids = Models::V1::PlaceMembership
          .select(:place_id)
          .where(user_id: user_id)
          .map(&:place_id)

        place_ids |= Models::V1::PlaceOrganizer
          .select(:place_id)
          .where(organizer_id: user_id)
          .map(&:place_id)

        Models::V1::Place.where(id: place_ids)
      end

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
