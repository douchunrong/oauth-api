require_relative 'base'
require_relative 'user'
# circular dependencies
# require_relative 'association'
# require_relative 'division'
# require_relative 'group'
# require_relative 'organization'
# require_relative 'place'
# require_relative 'profile'

module Models
  module V1
    # Being a Membership means you can check into private <Things>, but may also
    # be useful for public <Things> too
    class Membership < ActiveRecord::Base
      extend Base

      belongs_to :user
    end

    class AssociationMembership < Membership
      belongs_to :assoc, class_name: 'Models::V1::Association'
    end

    class DivisionMembership < Membership
      belongs_to :division
    end

    class PlaceMembership < Membership
      belongs_to :place
    end

    class OrganizationMembership < Membership
      belongs_to :organization
    end

    class GroupMembership < Membership
      belongs_to :group
    end

    class GroupProfileMembership < Membership
      belongs_to :group
      belongs_to :profile
    end
  end
end
