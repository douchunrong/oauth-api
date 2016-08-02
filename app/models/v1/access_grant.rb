require_relative 'base'
require_relative 'profile'
require_relative 'user'
require_relative 'waiver_signing'

module Models
  module V1
    class AccessGrant < ActiveRecord::Base
      extend Base

      belongs_to :profile
      belongs_to :granted_by, class_name: 'Models::V1::User'
      # # attr_accessible :granted_at
      # # attr_accessible :expired_at
      belongs_to :waiver_signing
    end
  end
end