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
require_relative 'group'
require_relative 'user'
require_relative 'waiver'

module Models
  module V1
    class Profile < ActiveRecord::Base
      extend Base
      extend Organizable

      # token :sport_id_code
      before_create :create_unique_identifier
      cattr_accessor :token_name

      self.token_name = 'sport_id_code'

      def create_unique_identifier
        # generate 10 random strings
        tokens = (1..10).to_a.map do
          t = (1..8).to_a.map { (65 + (rand() * 26).floor).chr }.join

          "SELECT CONVERT('#{ t }' using latin1) as token"
        end

        result = ActiveRecord::Base.connection.execute(%Q{
          SELECT token FROM ( #{ tokens.join(' UNION ') } ) as tokens
          WHERE NOT EXISTS (
            SELECT 1
            FROM `#{ self.class.table_name }`
            WHERE `#{ self.class.token_name }` = tokens.token
          )
          LIMIT 1;
        })

        result.first.try(:first)

        self.send :"#{ self.class.token_name }=", result.first.try(:first)
      end

      # user's can flag one profile as their own
      belongs_to :user

      has_many :access_grants
      # @todo: place_participants?
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
      has_many :groups, through: :team_membership

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
        self.class.serialized_scoped_data(profile_data, scope_names)
      end

      class << self
        def with_profile_data(val)
          ProfileDatum
            .select(:profile_id)
            .where('value LIKE ?', "%#{ val }%")
        end

        # take all profile data and group it by scope and type
        # then if scope_names is nil, fill in any missing scopes
        # if not empty, return only the specified scopes
        # if empty (but not null), do not fill in the missing scopes
        def serialized_scoped_data(profile_data, scope_names = nil)
          data_map = profile_data.group_by(&:profile_data_type_id)
          only_available_data = !scope_names.nil? && scope_names.empty?

          # todo: cache this!
          scopes = Scope.includes(:profile_data_types).entries
          if scope_names.present?
            # would #select! modify the cached query above?
            scopes = scopes.select { |s| scope_names.include?(s.name) }
          end

          scopes.map do |scope|
            types_hash = scope.profile_data_types.map do |type|
              if data_map.key?(type.id)
                type_data = type.singular ?
                  data_map[type.id].first.data_value.as_json :
                  data_map[type.id].map(&:data_value).map(&:as_json)
              end

              type.as_json({
                only: %i(name description label singular).freeze
              }).merge(data: type_data)
            end

            next if only_available_data && types_hash.none? { |h| h[:data].present? }

            scope.as_json({
              only: %i(name description label).freeze
            }).merge(types: types_hash)
          end
          .compact # will only apply in "only_available_types" scenarios
        end
      end
    end
  end
end
