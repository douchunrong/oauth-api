require_relative 'base'
require_relative 'waiver'
require_relative 'signature'
require_relative 'access_grant'

module Models
  module V1
    class WaiverSigning < ActiveRecord::Base
      extend Base

      belongs_to :waiver
      belongs_to :signature, class_name: 'Models::V1::Signature'

      has_one :access_grant
    end
  end
end
