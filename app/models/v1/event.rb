require_relative '../../helpers/organizable'
require_relative 'base'
require_relative 'sport'
require_relative 'attachment'
require_relative 'event_participant'
require_relative 'external_source'
require_relative 'invite'
require_relative 'location'
require_relative 'organizer'
require_relative 'waiver'

module Models
  module V1
    class Event < ActiveRecord::Base
      extend Base
      extend Organizable

      # attr_accessible :name, :description, :website, :begins_at, :ends_at, :event_type, :age_group

      belongs_to :sport
      belongs_to :logo, class_name: 'Models::V1::Attachment'

      has_many :participants, class_name: 'Models::V1::EventParticipant'
      has_many :invites, class_name: 'Models::V1::EventInvite'
      has_many :locations, class_name: 'Models::V1::EventLocation'
      has_many :organizers, class_name: 'Models::V1::EventOrganizer'
      has_many :external_sources, class_name: 'Models::V1::EventExternalSource'
      has_many :waivers, class_name: 'Models::V1::EventWavier'

      class << self
        def accessible_to(user)
          # even though organizable, show all
          all
        end
      end
    end
  end
end
