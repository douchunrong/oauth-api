require_relative '../../helpers/organizable'
require_relative 'base'
require_relative 'division'
require_relative 'division_type'
require_relative 'invite'
require_relative 'location'
require_relative 'organization_number'
require_relative 'organizer'
require_relative 'resource_external_source'
require_relative 'team'
require_relative 'waiver'

module Models
  module V1
    class Organization < ActiveRecord::Base
      extend Base
      extend Organizable

      # attr_accessible :name, :description

      has_many :division_types
      has_many :divisions
      # don't remember why I put this here
      # has_many :external_source
      has_many :invites, class_name: 'Models::V1::OrganizationInvite'
      has_many :locations, class_name: 'Models::V1::OrganizationLocation'
      has_many :organization_numbers
      has_many :organizers, class_name: 'Models::V1::OrganizationOrganizer'
      has_many :resource_external_sources, class_name: 'Models::V1::OrganizationExternalSource'
      has_many :waivers, class_name: 'Models::V1::OrganizationWavier'
      has_many :teams
    end
  end
end
