require_relative 'base'
require_relative 'external_source'
require_relative 'association'
require_relative 'division'
require_relative 'event'
require_relative 'organization'
require_relative 'profile'
require_relative 'team'

module Models
  module V1
    class ResourceExternalSource < ActiveRecord::Base
      extend Base

      belongs_to :external_source

      # attr_accessible :identifier
    end

    class AssociationExternalSource < ResourceExternalSource
      belongs_to :assoc, class_name: 'Models::V1::Association'
    end

    class DivisionExternalSource < ResourceExternalSource
      belongs_to :division
    end

    class EventExternalSource < ResourceExternalSource
      belongs_to :event
    end

    class OrganizationExternalSource < ResourceExternalSource
      belongs_to :organization
    end

    class ProfileExternalSource < ResourceExternalSource
      belongs_to :profile
    end

    class TeamExternalSource < ResourceExternalSource
      belongs_to :team
    end
  end
end
