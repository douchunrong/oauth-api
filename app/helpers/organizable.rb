# circular dependency
# require_relative '../models/v1/organizer'

module Models
  module V1
    module Organizable
      def accessible_to(user)
        return all if user.admin?

        where(id: Organizer.resources_for_user(self, user))
      end
    end
  end
end
