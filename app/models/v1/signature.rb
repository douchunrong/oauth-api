require_relative 'base'
require_relative 'user'
require_relative 'waiver'

module Models
  module V1
    class Signature < ActiveRecord::Base
      extend Base

      belongs_to :signed_by, class_name: 'Models::V1::User'
      has_one :waivers, through: :waiver_signing
    end

    class PngSignature < Signature
      # attr_accessible :base64
    end

    class SvgSignature < Signature
      # attr_accessible :markup
    end
  end
end
