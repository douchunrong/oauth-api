require_relative '../../helpers/organizable'
require_relative 'base'
require_relative 'association'
require_relative 'attachment'
require_relative 'division'
require_relative 'event_participant'
require_relative 'external_source'
require_relative 'invite'
require_relative 'location'
require_relative 'organization'
require_relative 'organizer'
require_relative 'profile'
require_relative 'sport'
require_relative 'waiver'

module Models
  module V1
    class Team < ActiveRecord::Base
      extend Base
      extend Organizable

      # attribute :name, String
      # attribute :description, String
      # attribute :website, String
      # attribute :age_group, String

      belongs_to :sport
      belongs_to :organization
      belongs_to :division
      belongs_to :assoc, class_name: 'Models::V1::Association'
      belongs_to :logo, class_name: 'Models::V1::Attachment'

      # has_many :external_sites
      has_many :event_participants, class_name: 'Models::V1::ProfileEventParticipant'
      has_many :invites, class_name: 'Models::V1::TeamInvite'
      has_many :locations, class_name: 'Models::V1::TeamLocation'
      has_many :organizers, class_name: 'Models::V1::TeamOrganizer'
      has_many :external_sources, class_name: 'Models::V1::TeamExternalSource'
      has_many :profiles, through: :team_membership
      has_many :waivers, class_name: 'Models::V1::TeamWavier'
    end
  end
end
