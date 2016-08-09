require_relative 'base'
require_relative 'profile_data_type'
require_relative 'signature'
require_relative 'association'
require_relative 'division'
require_relative 'place'
require_relative 'organization'
require_relative 'profile'
require_relative 'group'

module Models
  module V1
    class Waiver < ActiveRecord::Base
      extend Base

      # attr_accessible :name, :body
      # attr_accessible :requires_signature, :requires_acceptance

      has_many :profile_data_types, through: :waiver_field
      has_many :signatures, through: :waiver_signing
    end

    class AssociationWavier < Waiver
      belongs_to :assoc, class_name: 'Models::V1::Association'
    end

    class DivisionWavier < Waiver
      belongs_to :division
    end

    class PlaceWavier < Waiver
      belongs_to :place
    end

    class OrganizationWavier < Waiver
      belongs_to :organization
    end

    # @todo: dafuq is a ProfileWaiver?
    class ProfileWavier < Waiver
      belongs_to :profile
    end

    class GroupWavier < Waiver
      belongs_to :group
    end
  end
end
