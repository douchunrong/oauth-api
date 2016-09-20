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

      # @todo: serializable_hash with core properties
      # and similar for subclasses appending only relevant properties

      protected

      def _data_value
        value
      end

      class << self
        def class_factory(type)
          descendants.find { |c| c.name == type } || self
        end

        def factory(profile, created_by, type, attributes)
          return if type.nil?

          klass = class_factory(type.data_type)

          klass.transaction do
            if type.singular?
              klass.destroy_all(profile: profile, profile_data_type: type)
            end

            attributes =
              ActionController::Parameters.new(attributes)
                .permit(klass.column_names)

            klass.new(attributes).tap do |instance|
              instance.profile_data_type = type
              instance.profile = profile
              instance.created_by = created_by

              instance.save!
            end
          end
        end

        # {
        #   "scope" => <scope_name>,
        #   "type" => <type_name>,
        #   "value" => <value>
        # }
        def from_request_hashes(hashes, profile = nil, created_by = nil)
          types = ProfileDataType.includes(:scope).all

          hashes.map { |h| from_request_hash(types, h, profile, created_by) }
        end

        private

        def from_request_hash(types, hash, profile, created_by)
          hash = hash.dup
          scope_name = hash.delete(:scope)
          type_name = hash.delete(:profile_data_type)

          type = types
            .find { |t| t.scope.name == scope_name && t.name == type_name }

          factory(profile, created_by, type, hash)
        rescue ActiveRecord::RecordInvalid => e
          logger.warn "Failed to create #{ name }"
          logger.warn e.message

          e.record.as_json.tap { |r| r[:error] = e.message }
        end
      end
    end

    class StringProfileDatum < ProfileDatum
      validates :value, presence: true
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

      validates :attachment_id, presence: true

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

      validates :contact_id, presence: true

      protected

      def _data_value
        contact
      end
    end

    # @todo: remove?
    class InsuranceProfileDatum < ProfileDatum
      belongs_to :insurance

      validates :insurance_id, presence: true

      protected

      def _data_value
        insurance
      end
    end

    # @todo: remove?
    class ProfileLocationProfileDatum < ProfileDatum
      belongs_to :location

      validates :location_id, presence: true

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
