# circular dependency
# require_relative '../models/v1/organizer'

module Models
  module V1
    module Organizable
      def accessible_to(user)
        where(id: Organizer.resources_for_user(self, user))
      end

      def createable_by?(user, params)
        return false if user.nil?

        super ||
          organizers.any? { |o| o.can_edit? && o.organizer_id = user.id }
      end

      def readable_by?(user)
        return false if user.nil?

        super ||
          organizers.any? { |o| o.can_read? && o.organizer_id = user.id }
      end

      def updateable_by?(user, params)
        return false if user.nil?

        super ||
          organizers.any? { |o| o.can_edit? && o.organizer_id = user.id }
      end

      # nothing special here
      # def deletable_by?(user)
      #   super
      # end
    end
  end
end
