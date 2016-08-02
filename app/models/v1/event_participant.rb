require_relative 'base'
require_relative 'event'
require_relative 'profile'
require_relative 'team'

module Models
  module V1
    class EventParticipant < ActiveRecord::Base
      extend Base

      belongs_to :event
    end

    class ProfileEventParticipant < EventParticipant
      belongs_to :profile
    end

    class TeamEventParticipant < EventParticipant
      belongs_to :team
    end
  end
end