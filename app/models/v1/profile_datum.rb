require_relative 'base'
require_relative 'profile'
require_relative 'profile_data_type'
# @todo: remove
require_relative 'attachment'
# @todo: remove
require_relative 'contact'
# @todo: remove
require_relative 'insurance'

module Models
  module V1
    class ProfileDatum < ActiveRecord::Base
      extend Base

      belongs_to :profile
      belongs_to :profile_data_type

      # attr_accessible :source, :value
    end

    # @todo: remove
    class AttachmentProfileDatum < ProfileDatum
      belongs_to :attachment
    end

    # @todo: remove
    class ContactProfileDatum < ProfileDatum
      belongs_to :contact
    end

    # @todo: remove
    class InsuranceProfileDatum < ProfileDatum
      belongs_to :insurance
    end
  end
end
