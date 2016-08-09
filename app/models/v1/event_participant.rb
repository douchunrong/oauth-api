require_relative 'base'
require_relative 'place'
require_relative 'profile'
require_relative 'group'

module Models
  module V1
    class EventParticipant < ActiveRecord::Base
      extend Base

      belongs_to :place
    end

    class ProfileEventParticipant < EventParticipant
      belongs_to :profile
    end

    class GroupEventParticipant < EventParticipant
      belongs_to :group
    end
  end
end