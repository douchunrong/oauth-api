require_relative '../../helpers/organizable'
require_relative 'base'
require_relative 'access_grant'
require_relative 'event_participant'
require_relative 'external_source'
require_relative 'invite'
require_relative 'location'
require_relative 'organization_number'
require_relative 'organizer'
require_relative 'profile_datum'
require_relative 'team'
require_relative 'user'
require_relative 'waiver'

module Models
  module V1
    class Profile < ActiveRecord::Base
      extend Base
      extend Organizable

      # token :sport_id_code

      # user's can flag one profile as their own
      belongs_to :user

      has_many :access_grants
      has_many :event_participants, class_name: 'Models::V1::ProfileEventParticipant'
      has_many :invites, class_name: 'Models::V1::ProfileInvite'
      has_many :locations, class_name: 'Models::V1::ProfileLocation'
      has_many :organization_numbers
      has_many :organizers, class_name: 'Models::V1::ProfileOrganizer'
      # plural hell!
      has_many :profile_data, {
        class_name: 'Models::V1::ProfileDatum',
        inverse_of: :profile
      }
      has_many :external_sources, class_name: 'Models::V1::ProfileExternalSource'
      has_many :teams, through: :team_membership

      # dafuq is a profile waiver?
      has_many :waivers, class_name: 'Models::V1::ProfileWavier'
    end
  end
end
