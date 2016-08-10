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

      default_scope do
        where(deleted_at: nil, accepted_at: nil, rejected_at: nil)
      end

      def resource
        raise NotImplementedError
      end

      def invite_type
        self.class.name.scan(/Models::V1::(.*?)Invite/).last.first
      end

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        (options[:methods] ||= []) << :invite_type

        super(options)
      end

      class << self
        def accessible_to(user)
          where('user_id = ? OR user_email = ?', user.id, user.email)
        end
      end
    end

    # class AssociationInvite < Invite
    #   belongs_to :assoc, class_name: 'Models::V1::Association'

    #   alias_method :resource, :assoc

    #   def serializable_hash(options = {})
    #     options = options.try(:clone) || {}

    #     unless [options[:exclude]].flatten.include?(:association)
    #       (options[:include] ||= []) << :association
    #     end

    #     super(options)
    #   end
    # end

    # class ContactInvite < Invite
    #   belongs_to :contact

    #   alias_method :resource, :contact

    #   def serializable_hash(options = {})
    #     options = options.try(:clone) || {}

    #     unless [options[:exclude]].flatten.include?(:contact)
    #       (options[:include] ||= []) << :contact
    #     end

    #     super(options)
    #   end
    # end

    class DivisionInvite < Invite
      belongs_to :division

      alias_method :resource, :division

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless [options[:exclude]].flatten.include?(:division)
          (options[:include] ||= []) << :division
        end

        super(options)
      end
    end

    class GroupInvite < Invite
      belongs_to :group

      alias_method :resource, :group

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless [options[:exclude]].flatten.include?(:group)
          (options[:include] ||= []) << :group
        end

        super(options)
      end
    end

    class OrganizationInvite < Invite
      belongs_to :organization

      alias_method :resource, :organization

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless [options[:exclude]].flatten.include?(:organization)
          (options[:include] ||= []) << :organization
        end

        super(options)
      end
    end

    class PlaceInvite < Invite
      belongs_to :place

      alias_method :resource, :place

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless [options[:exclude]].flatten.include?(:place)
          (options[:include] ||= []) << :place
        end

        super(options)
      end
    end

    class ProfileInvite < Invite
      belongs_to :profile

      alias_method :resource, :profile

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless [options[:exclude]].flatten.include?(:profile)
          (options[:include] ||= []) << :profile
        end

        super(options)
      end
    end

    # class UserInvite < Invite
    #   belongs_to :invited, {
    #     class_name: 'Models::V1::User',
    #     inverse_of: :invites
    #   }
    # end
  end
end
