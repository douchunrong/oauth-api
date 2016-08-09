require_relative 'base'
require_relative 'user'
require_relative 'association'
require_relative 'contact'
require_relative 'division'
require_relative 'place'
require_relative 'organization'
require_relative 'profile'
require_relative 'group'

module Models
  module V1
    class Invite < ActiveRecord::Base
      extend Base

      # attr_accessible :user_email, :invited_by_friendly_name, :message, :token, :pass_phrase, :accepted_at, :rejected_at

      belongs_to :invited_by, {
        class_name: 'Models::V1::User',
        inverse_of: :invitations
      }

      class << self
        def accessible_to(user)
          where({
            id: self.select(:id).where(user_email: user.email)
              # .where('user_id = ? OR user_email = ?', user.id, user.email)
          })
        end
      end
    end

    class AssociationInvite < Invite
      belongs_to :assoc, class_name: 'Models::V1::Association'
    end

    # class ContactInvite < Invite
    #   belongs_to :contact
    # end

    class DivisionInvite < Invite
      belongs_to :division
    end

    class PlaceInvite < Invite
      belongs_to :place
    end

    class OrganizationInvite < Invite
      belongs_to :organization
    end

    class ProfileInvite < Invite
      belongs_to :profile
    end

    class GroupInvite < Invite
      belongs_to :group
    end

    # class UserInvite < Invite
    #   belongs_to :invited, {
    #     class_name: 'Models::V1::User',
    #     inverse_of: :invites
    #   }
    # end
  end
end
