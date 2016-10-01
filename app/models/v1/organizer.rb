require_relative 'base'
require_relative 'user'
require_relative 'organizer_type'
# circular dependencies
# require_relative 'association'
# require_relative 'division'
# require_relative 'place'
# require_relative 'organization'
# require_relative 'profile'
# require_relative 'group'

module Models
  module V1
    class Organizer < ActiveRecord::Base
      extend Base

      belongs_to :organizer, class_name: 'Models::V1::User'
      belongs_to :organizer_type

      # attr_accessible :can_edit, :can_add_organizer

      default_scope { includes(:organizer_type) }

      def serializable_hash(options = {})
        options ||= {}

        options[:include] = Array(options[:include])
        options[:include] << :organizer_type

        # @todo: optimization opportunity: OrganizerType.entries is likely
        # cached, so no need to fetch for each here
        super(options).tap do |hash|
          hash[:organizer] = organizer.as_json({
            include: {
              profile: {
                include: :profile_data,
                scopes: ['profile.identification']
              }
            }
          })
        end
      end

      class << self
        protected

        attr_accessor :resource_class, :resource_field

        def resource(attribute, class_name, field = nil)
          belongs_to attribute, class_name: class_name

          self.resource_class = class_name
          self.resource_field = field || "#{ attribute }_id".to_sym
        end

        public

        def class_factory(resource_class)
          class_name = resource_class.name

          klass = descendants.find { |c| c.resource_class == class_name }

          klass || self
        end

        def resources_for_user(resource_class, user)
          klass = class_factory(resource_class)

          klass.select(klass.resource_field).where(organizer_id: user.id)
        end
      end
    end

    # e.g. Director
    class AssociationOrganizer < Organizer
      resource :assoc, 'Models::V1::Association', :association_id
    end

    # e.g., Regional VP
    class DivisionOrganizer < Organizer
      resource :division, 'Models::V1::Division'
    end

    # e.g., Host
    class PlaceOrganizer < Organizer
      resource :place, 'Models::V1::Place'
    end

    # e.g., President
    class OrganizationOrganizer < Organizer
      resource :organization, 'Models::V1::Organization'
    end

    # e.g., Parent
    class ProfileOrganizer < Organizer
      resource :profile, 'Models::V1::Profile'
    end

    # e.g., Coach
    class GroupOrganizer < Organizer
      resource :group, 'Models::V1::Group'
    end
  end
end
