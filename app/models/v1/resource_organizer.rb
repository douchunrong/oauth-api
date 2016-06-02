require_relative 'checkin'

module Models::V1
  ResourceOrganizer = Struct.new(:resource, :user, :role) do
    def as_json(options = {})
      {
        user: user.as_json,
        role: role.as_json
      }
    end

    class << self
      def default_role
        raise NotImplemntedError
      end

      def for_resource(resource)
        organizer_ids = resource.postmetas
          .select { |m| m.meta_key == 'organizer'.freeze }
          .map(&:meta_value)

        User.where(id: organizer_ids)
          .map { |u| new(resource, u, default_role) }
      end
    end
  end

  class EventOrganizer < ResourceOrganizer
    module Roles
      DIRECTOR = 'director'.freeze
      ADMINISTRATOR = 'administrator'.freeze
      TRAINOR = 'trainor'.freeze
    end

    alias event resource

    class << self
      def default_role
        Roles::ADMINISTRATOR
      end
    end
  end

  class TeamOrganizer < ResourceOrganizer
    module Roles
      COACH = 'coach'.freeze
      ADMINISTRATOR = 'administrator'.freeze
      TRAINOR = 'trainor'.freeze
    end

    alias team resource

    class << self
      def default_role
        Roles::ADMINISTRATOR
      end
    end
  end
end
