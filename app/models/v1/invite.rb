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

      validates :user_email, {
        presence: true,
        unless: Proc.new { |a| a.user_id.present? }
      }

      validates :user_id, {
        presence: true,
        unless: Proc.new { |a| a.user_email.present? }
      }

      default_scope do
        where(deleted_at: nil, accepted_at: nil, rejected_at: nil)
      end

      cattr_accessor :token_name

      self.token_name = 'token'

      # @todo: move to a module
      before_create :create_unique_identifier
      def create_unique_identifier
        return unless self.class.token_name.present?

        # generate 10 random strings
        tokens = (1..10).to_a.map do
          t = (1..8).to_a.map { (65 + (rand() * 26).floor).chr }.join

          "SELECT CONVERT('#{ t }' using latin1) as token"
        end

        result = ActiveRecord::Base.connection.execute(%Q{
          SELECT token FROM ( #{ tokens.join(' UNION ') } ) as tokens
          WHERE NOT EXISTS (
            SELECT 1
            FROM `#{ self.class.table_name }`
            WHERE `#{ self.class.token_name }` = tokens.token
          )
          LIMIT 1;
        })

        self.send :"#{ self.class.token_name }=", result.first.try(:first)
      end

      def resource
        raise NotImplementedError
      end

      def invite_type
        self.class.name.scan(/Models::V1::(.*?)Invite/).last.first
      end

      def createable_by?(user, params = {})
        return false if user.nil?

        return true if super

        return true if user_id == user.id || user_email == user.email

        token == params[:token] &&
          (pass_phrase.nil? || pass_phrase == params[:pass_phrase])
      end

      def readable_by?(user)
        return false if user.nil?

        super || user_id == user.id || user_email == user.email
      end

      def updateable_by?(user, params = {})
        return false if user.nil?

        return true if super

        return true if user_id == user.id || user_email == user.email

        token == params[:token] &&
          (pass_phrase.nil? || pass_phrase == params[:pass_phrase])
      end

      def deletable_by?(user)
        return false if user.nil?

        super || user_id == user.id || user_email == user.email
      end

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        (options[:methods] ||= []) << :invite_type
        (options[:except] ||= []) << :token << :pass_phrase

        super(options)
      end

      class << self
        def class_factory(resource_class)
          invite_class = "#{ resource_class.name }Invite"

          klass = descendants
            .find { |c| c.name == resource_class.name || c.name == invite_class }

          klass || self
        end

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

    #     unless Array(options[:exclude]).include?(:association)
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

    #     unless Array(options[:exclude]).include?(:contact)
    #       (options[:include] ||= []) << :contact
    #     end

    #     super(options)
    #   end
    # end

    class DivisionInvite < Invite
      belongs_to :division

      validates :division_id, presence: true

      alias_method :resource, :division

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless Array(options[:exclude]).include?(:division)
          (options[:include] ||= []) << :division
        end

        super(options)
      end
    end

    class GroupInvite < Invite
      belongs_to :group

      validates :group_id, presence: true

      alias_method :resource, :group

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless Array(options[:exclude]).include?(:group)
          (options[:include] ||= []) << :group
        end

        super(options)
      end
    end

    class OrganizationInvite < Invite
      belongs_to :organization

      validates :organization_id, presence: true

      alias_method :resource, :organization

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless Array(options[:exclude]).include?(:organization)
          (options[:include] ||= []) << :organization
        end

        super(options)
      end
    end

    class PlaceInvite < Invite
      belongs_to :place

      validates :place_id, presence: true

      alias_method :resource, :place

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless Array(options[:exclude]).include?(:place)
          (options[:include] ||= []) << :place
        end

        super(options)
      end
    end

    class ProfileInvite < Invite
      belongs_to :profile

      validates :profile_id, presence: true

      alias_method :resource, :profile

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless Array(options[:exclude]).include?(:profile)
          (options[:include] ||= []) << :profile
        end

        super(options)
      end
    end

    class DivisionOrganizerInvite < DivisionInvite
      belongs_to :organizer_type

      validates :organizer_type_id, presence: true

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless Array(options[:exclude]).include?(:organizer_type)
          (options[:include] ||= []) << :organizer_type
        end

        super(options)
      end
    end

    class GroupOrganizerInvite < GroupInvite
      belongs_to :organizer_type

      validates :organizer_type_id, presence: true

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless Array(options[:exclude]).include?(:organizer_type)
          (options[:include] ||= []) << :organizer_type
        end

        super(options)
      end
    end

    class OrganizationOrganizerInvite < OrganizationInvite
      belongs_to :organizer_type

      validates :organizer_type_id, presence: true

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless Array(options[:exclude]).include?(:organizer_type)
          (options[:include] ||= []) << :organizer_type
        end

        super(options)
      end
    end

    class PlaceOrganizerInvite < PlaceInvite
      belongs_to :organizer_type

      validates :organizer_type_id, presence: true

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless Array(options[:exclude]).include?(:organizer_type)
          (options[:include] ||= []) << :organizer_type
        end

        super(options)
      end
    end

    class ProfileOrganizerInvite < ProfileInvite
      belongs_to :organizer_type

      validates :organizer_type_id, presence: true

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        unless Array(options[:exclude]).include?(:organizer_type)
          (options[:include] ||= []) << :organizer_type
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
