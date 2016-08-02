require_relative 'base'
require_relative 'association'
require_relative 'division'
require_relative 'event'
require_relative 'organization'
require_relative 'profile'
require_relative 'team'

module Models
  module V1
    # @todo: Combine v1_location w/v1_resource_location
    class Location < ActiveRecord::Base
      extend Base

      # attr_accessible :name, :description, :address
      # attr_accessible :user_latitude, :user_longitude
      # attr_accessible :latitude, :longitude

      # not positive what this is...
      # has_many :resources, class_name: 'Models::V1::ResourceLocation'
    end

    class AssociationLocation < Location
      belongs_to :assoc, class_name: 'Models::V1::Association'
    end

    class DivisionLocation < Location
      belongs_to :division
    end

    class EventLocation < Location
      belongs_to :event
    end

    class OrganizationLocation < Location
      belongs_to :organization
    end

    class ProfileLocation < Location
      belongs_to :profile
    end

    class TeamLocation < Location
      belongs_to :team
    end
  end
end
