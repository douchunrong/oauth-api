require_relative '../../models/v1/place'
require_relative '../../models/v1/organizer'
require_relative 'api_controller'

module Controllers
  module V1
    class PlacesController < ApiController
      self.model_class = Models::V1::Place

      protected

      PERMITTABLE_INCLUDES = %i(
        locations
        logo
        sport
        waivers
      ).freeze

      ADMIN_PERMITTABLE_INCLUDES = %i(
        locations
        logo
        sport
        waivers

        participants
        invites
        organizers
        external_sources
      ).freeze

      def permittable_list_includes
        includes = params[:include].split(',').map(&:to_sym)

        includes & PERMITTABLE_INCLUDES
      end

      def permittable_read_includes(resource_id)
        includes = params[:include].split(',').map(&:to_sym)

        # @todo: you *could* do a check to see whether this is even necessary
        permittables = Models::V1::PlaceOrganizer.where(
          organizer_id: current_user_id,
          place_id: resource_id
        ).exists? ? ADMIN_PERMITTABLE_INCLUDES : PERMITTABLE_INCLUDES

        includes & permittables
      end
    end
  end
end
