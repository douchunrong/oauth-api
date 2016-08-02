require_relative '../../helpers/organizable'
require_relative 'base'
require_relative 'external_source'
require_relative 'invite'
require_relative 'location'
require_relative 'organizer'
require_relative 'waiver'

module Models
  module V1
    class Association < ActiveRecord::Base
      extend Base
      extend Organizable

      # attr_accessible :name
      # attr_accessible :description

      has_many :invites, {
        class_name: 'Models::V1::AssociationInvite',
        inverse_of: :assoc
      }
      has_many :locations, {
        class_name: 'Models::V1::AssociationLocation',
        inverse_of: :assoc
      }
      has_many :organizers, {
        class_name: 'Models::V1::AssociationOrganizer',
        inverse_of: :assoc
      }
      has_many :external_sources, {
        class_name: 'Models::V1::AssociationExternalSource',
        inverse_of: :assoc
      }
      has_many :waivers, {
        class_name: 'Models::V1::AssociationWaiver',
        inverse_of: :assoc
      }
      has_many :teams, inverse_of: :assoc
    end
  end
end
