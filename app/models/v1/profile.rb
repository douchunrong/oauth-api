require_relative '../../helpers/organizable'
require_relative 'base'
require_relative 'access_grant'
require_relative 'event_participant'
require_relative 'external_source'
require_relative 'invite'
require_relative 'location'
require_relative 'organization_number'
require_relative 'organizer'
require_relative 'profile_datum'
require_relative 'team'
require_relative 'user'
require_relative 'waiver'

module Models
  module V1
    class Profile < ActiveRecord::Base
      extend Base
      extend Organizable

      # token :sport_id_code

      # user's can flag one profile as their own
      belongs_to :user

      has_many :access_grants
      has_many :event_participants, class_name: 'Models::V1::ProfileEventParticipant'
      has_many :invites, class_name: 'Models::V1::ProfileInvite'
      has_many :locations, class_name: 'Models::V1::ProfileLocation'
      has_many :organization_numbers
      has_many :organizers, class_name: 'Models::V1::ProfileOrganizer'
      # plural hell!
      has_many :profile_data, {
        class_name: 'Models::V1::ProfileDatum',
        inverse_of: :profile
      }
      has_many :external_sources, class_name: 'Models::V1::ProfileExternalSource'
      has_many :teams, through: :team_membership

      # dafuq is a profile waiver?
      has_many :waivers, class_name: 'Models::V1::ProfileWavier'

      # accepts standard otions as well as one special option: scopes
      def serializable_hash(options = {})
        options ||= {}

        return super unless [options[:include]].flatten.include?(:profile_data)

        super(except: :profile_data).tap do |hash|
          hash[:profile_data] = serialized_scoped_data(options[:scopes])
        end
      end

      def serialized_scoped_data(scope_names = nil)
        data_map = profile_data.group_by(&:profile_data_type_id)

        # todo: cache this!
        scopes = Scope.includes(:profile_data_types).entries
        scopes.select { |s| scope_names.include?(s) } unless scope_names.nil?

        scopes.map do |scope|
          types_hash = scope.profile_data_types.map do |type|
              if data_map.key?(type.id)
                type_data = type.singular ?
                  data_map[type.id].first.data_value.as_json :
                  data_map[type.id].map(&:data_value).map(&:as_json)
              end

              type.as_json({
                only: %i(name description label singular).freeze
              }).merge(type_data: type_data)
            end

          scope.as_json({
            only: %i(name description label).freeze
          }).merge(types: types_hash)
        end
      end

      class << self
        def with_profile_data(val)
          ProfileDatum
            .select(:profile_id)
            .where('value LIKE ?', "%#{ val }%")
        end
      end
    end
  end
end
