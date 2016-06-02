require 'phpass'

require_relative 'active_record_sequel_adapter'
require_relative 'data_exposure_methods'
require_relative 'checkin'
require_relative 'event'

module Models::V1
  class User < WPDB::User
    include ActiveRecordSequelAdapter
    include DataExposureMethods

    attr_accessor :meta_lookup

    def after_initialize
      self.meta_lookup = Hash[
        usermeta.map { |m| [m.meta_key.to_sym, m] }
      ]
    end

    plugin :after_initialize

    field :created_at, :user_registered
    field :email, :user_email
    field :id, :ID
    field :login, :user_login

    ignore :display_name
    ignore :user_activation_key
    ignore :user_nicename
    ignore :user_pass
    ignore :user_status
    ignore :user_url

    metafield :first_name
    metafield :last_name

    one_to_many :checkins_created, {
      key: :post_author,
      primary_key: :ID,
      class: 'V1::Checkin'
    }

    # one_to_many :checkins, {
    #   key: :checked_in_by,
    #   class: :'V1::Checkin'
    # }
    def checkins
      checkins_created
    end

    one_to_many :events_created, {
      key: :post_author,
      primary_key: :ID,
      class: 'V1::Event'
    }

    # one_to_many :events, {
    #   ...
    #   class: :'V1::Event'
    # }
    def events
      events_created
    end

    ADMIN_USER_LEVEL = '10'.freeze
    def admin?
      meta_lookup[:wp_user_level].try(:meta_value) == ADMIN_USER_LEVEL
    end

    # validates :email, presence: true

    def authenticate(password)
      Phpass.new(8).check(password, user_pass)
    end

    class << self
      def find_by_email(email)
        where(user_email: email).limit(1).first
      end
    end
  end
end
