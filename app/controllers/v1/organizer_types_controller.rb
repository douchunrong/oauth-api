require_relative '../../models/v1/organizer_type'
require_relative '../../models/v1/organizer'
require_relative 'api_controller'

module Controllers
  module V1
    class OrganizerTypesController < ApiController
      self.model_class = Models::V1::OrganizerType
    end

    class ProfileOrganizerTypesController < ApiController
      self.model_class = Models::V1::OrganizerType

      def list(params)
        super
          .where(organizer_type: Models::V1::ProfileOrganizer.name)
          .where.not(label: nil)
      end
    end
  end
end
