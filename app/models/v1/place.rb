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
    class Place < ActiveRecord::Base
      extend Base
      extend Organizable

      # attr_accessible :name, :description, :website, :begins_at, :ends_at, :event_type, :age_group

      belongs_to :sport
      belongs_to :logo, class_name: 'Models::V1::Attachment'

      has_many :participants, class_name: 'Models::V1::PlaceParticipant'
      has_many :invites, class_name: 'Models::V1::PlaceInvite'
      has_many :locations, class_name: 'Models::V1::PlaceLocation'
      has_many :members, class_name: 'Models::V1::PlaceMembership'
      has_many :organizers, class_name: 'Models::V1::PlaceOrganizer'
      has_many :external_sources, class_name: 'Models::V1::PlaceExternalSource'
      has_many :waivers, class_name: 'Models::V1::PlaceWavier'

      # nothing special here
      # def createable_by?(user, params = {})
      #   super
      # end

      def readable_by?(user)
        participant = false # @todo

        !private? || super || participant
      end

      # nothing special here
      # def updateable_by?(user, params = {})
      #   super
      # end

      # nothing special here
      # def deletable_by?(user)
      #   super
      # end

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        if association(:logo).loaded?
          options[:include] = [options[:include]].flatten.compact << :logo
        end

        super(options)
      end

      class << self
        def accessible_to(user)
          # even though organizable, show all
          all
        end
      end
    end

    class EventPlace < Place; end
  end
end
