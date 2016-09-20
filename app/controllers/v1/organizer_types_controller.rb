require_relative '../../models/v1/organizer_type'
require_relative '../../models/v1/organizer'
require_relative 'api_controller'

module Controllers
  module V1
    class OrganizerTypesController < ApiController
      self.model_class = Models::V1::OrganizerType

      def list(params, includes = nil)
        super
          .tap { |q| q.includes(includes) unless includes.nil? }
          .where(organizer_type: self.class.organizer_class.name)
          .where.not(label: nil)
      end

      class << self
        attr_accessor :organizer_class
      end
    end

    class ProfileOrganizerTypesController < OrganizerTypesController
      self.model_class = Models::V1::OrganizerType
      self.organizer_class = Models::V1::ProfileOrganizer
    end

    class PlaceOrganizerTypesController < OrganizerTypesController
      self.model_class = Models::V1::OrganizerType
      self.organizer_class = Models::V1::PlaceOrganizer
    end

    class GroupOrganizerTypesController < OrganizerTypesController
      self.model_class = Models::V1::OrganizerType
      self.organizer_class = Models::V1::GroupOrganizer
    end
  end
end
