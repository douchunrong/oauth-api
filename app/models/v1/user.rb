require 'phpass'

require_relative 'base'
# to avoid circular dependencies, do not `require` other classes here.

module Models
  module V1
    class WaiverSigning < ActiveRecord::Base
      extend Base

      belongs_to :waiver
      belongs_to :signature, class_name: 'Models::V1::Signature'

      has_one :access_grant
    end

    class User < ActiveRecord::Base
      self.table_name = 'wp_users'

      extend Base
      def self.default_scope; end

      def self.columns
        super.reject do |column|
          %w(
            user_login
            user_nicename
            user_url
            user_activation_key
            user_status
            display_name
          ).include?(column.name)
        end
      end

      # accessors are created on the fly, so `alias` complains
      def id; self.ID; end
      def created_at; user_registered; end
      def modified_at; user_registered; end
      def email; user_email; end
      def email=(val); self.user_email = val; end

      def as_json(options = {})
        super(only: [], methods: %w(id created_at modified_at email))
      end

      def admin?
        user_email =~ /@(sprtid|sportidapp).com/i
      end

      # do not expose our WP internals
      def serializable_hash(options = {})
        {
          id: id,
          created_at: created_at,
          modified_at: modified_at,
          email: email
        }
      end

      private

      has_many :access_grants, inverse_of: :granted_by
      has_many :invitations, inverse_of: :invited_by
      has_many :invites, class_name: 'Models::V1::UserInvite'
      # user's can flag one profile as their own
      has_one :profile
      has_many :signatures, inverse_of: :signed_by

      class << self
        def authenticate(email, password)
          user = find_by(user_email: email)

          # @todo: do not bring password back from the database,
          #        instead, hash it here, and pass that to the DB
          return unless Phpass.new(8).check(password, user.user_pass)

          user
        end
      end
    end
  end
end
