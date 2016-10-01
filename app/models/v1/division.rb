require_relative '../../helpers/organizable'
require_relative 'base'
require_relative 'division_type'
require_relative 'external_source'
require_relative 'invite'
require_relative 'location'
require_relative 'organizer'
require_relative 'group'
require_relative 'waiver'

module Models
  module V1
    class Division < ActiveRecord::Base
      extend Base
      extend Organizable

      # attr_accessible :name, :description

      belongs_to :organization
      belongs_to :parent, class_name: 'Models::V1::Division'
      belongs_to :division_type

      has_many :divisions, inverse_of: :parent
      has_many :external_sources, class_name: 'Models::V1::DivisionExternalSource'
      has_many :invites, class_name: 'Models::V1::DivisionInvite'
      has_many :locations, class_name: 'Models::V1::DivisionLocation'
      has_many :members, class_name: 'Models::V1::DivisionMembership'
      has_many :organizers, class_name: 'Models::V1::DivisionOrganizer'
      has_many :groups
      has_many :waivers, class_name: 'Models::V1::DivisionWaiver'
    end
  end
end
