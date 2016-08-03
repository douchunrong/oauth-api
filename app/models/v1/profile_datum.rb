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
      self.table_name = 'v1_profile_data' # ironically, this (the plural) is correct!

      extend Base

      belongs_to :profile
      belongs_to :profile_data_type

      # attr_accessible :source, :value

      def data_value
        return { applicable: false } unless applicable

        _data_value
      end

      protected

      def _data_value
        value
      end
    end

    class StringProfileDatum < ProfileDatum
    end

    class DateProfileDatum < ProfileDatum
    end

    class EnumProfileDatum < ProfileDatum
    end

    class GenderEnumProfileDatum < EnumProfileDatum
    end

    # @todo: remove?
    class AttachmentProfileDatum < ProfileDatum
      belongs_to :attachment

      protected

      def _data_value
        attachment
      end
    end

    # @todo: remove?
    class ProofOfAgeAttachmentProfileDatum < AttachmentProfileDatum
    end

    # @todo: remove?
    class ProfilePhotoAttachmentProfileDatum < AttachmentProfileDatum
    end

    # @todo: remove?
    class ContactProfileDatum < ProfileDatum
      belongs_to :contact

      protected

      def _data_value
        contact
      end
    end

    # @todo: remove?
    class InsuranceProfileDatum < ProfileDatum
      belongs_to :insurance

      protected

      def _data_value
        insurance
      end
    end

    # @todo: remove?
    class ProfileLocationProfileDatum < ProfileDatum
      belongs_to :location

      protected

      def _data_value
        location
      end
    end
  end
end

# UPDATE v1_profile_data SET type = 'Models::V1::StringProfileDatum' WHERE type = 'String';
# UPDATE v1_profile_data SET type = 'Models::V1::GenderEnumProfileDatum' WHERE type = 'Enum(Male,Female)';
# UPDATE v1_profile_data SET type = 'Models::V1::DateProfileDatum' WHERE type = 'Date';
# UPDATE v1_profile_data SET type = 'Models::V1::ContactProfileDatum' WHERE type = 'Models::V1::Contact';
# UPDATE v1_profile_data SET type = 'Models::V1::InsuranceProfileDatum' WHERE type = 'Models::V1::Insurance';
# UPDATE v1_profile_data SET type = 'Models::V1::ProofOfAgeAttachmentProfileDatum' WHERE type = 'Models::V1::ProofOfAgeAttachment';
# UPDATE v1_profile_data SET type = 'Models::V1::ProfilePhotoAttachmentProfileDatum' WHERE type = 'Models::V1::ProfilePhotoAttachment';
# UPDATE v1_profile_data SET type = 'Models::V1::ProfilePhotoAttachmentProfileDatum' WHERE type = 'Models::V1::ProfilePhotoAttachment';
# UPDATE v1_profile_data SET type = 'Models::V1::ProfileLocationProfileDatum' WHERE type = 'Models::V1::ProfileLocation';
