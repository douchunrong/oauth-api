require 'phpass'

require_relative 'active_record_sequel_adapter'
require_relative 'data_exposure_methods'

module V1
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

    alias_method :created_at, :user_registered
    alias_method :email, :user_email
    alias_method :id, :ID
    alias_method :login, :user_login

    ignore :user_pass

    field :first_name
    field :last_name

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
