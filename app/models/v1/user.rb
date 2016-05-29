require 'phpass'

require_relative 'active_record_sequel_adapter'
require_relative 'data_exposure_methods'
require_relative 'meta_lookup_methods'

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

    def check_password(plaintext_password)
      Phpass.new(8).check(plaintext_password, user_pass)
    end
  end
end
