require_relative 'pods_model'
require_relative 'image'
require_relative 'location'
require_relative 'resource_organizer'
require_relative 'sport'
require_relative 'waiver'

module Models::V1
  ExternalSiteId = Struct.new(:site, :id)

  class Team < PodsModel
    include DataExposureMethods

    pods_type('sprtid_team')

    initialize_common_pods_methods!

    metafield :type, :event_type
    metafield :begins_at, :event_start
    metafield :ends_at, :event_end
    metafield :sport_id, :sport

    many_to_one :created_by, {
      key: :post_author,
      primary_key: :ID,
      class: 'Models::V1::User'
    }

    # one_to_one :logo, {
    #   key: :ID,
    #   primary_key: :logo,
    #   class: 'Models::V1::Image'
    # }
    def logo
      Image.find(meta_value(:logo))
    end

    def external_ids
      JSON.parse(meta_value(:team_id))
        .map { |s, i| ExternalSiteId.new(s, i) }
    rescue => e
      nil
    end

    def locations
      [
        Location.from_address(
          Address.new(
            meta_value(:street_address),
            meta_value(:unit),
            meta_value(:city),
            meta_value(:state),
            meta_value(:zip)
          )
        )
      ]
    end

    def metadata
      meta = meta_value(:_wp_attachment_metadata)

      return unless meta.present?

      PHP.unserialize meta
    end

    def organizers
      TeamOrganizer.for_resource(self)
    end

    def sport
      Sport.find(sport_id)
    end

    def waiver
      [Waiver.new(meta_value(:terms), nil)]
    end

    def as_json(options = {})
      options = options.try(:clone) || {}

      options[:methods] ||= []
      options[:methods] << :external_ids
      options[:methods] << :locations
      options[:methods] << :logo
      options[:methods] << :metadata
      options[:methods] << :organizers
      options[:methods] << :sport
      options[:methods] << :waiver

      super(options)
    end

    def readable_by?(user)
      return true if created_by_id == user.id

      return true if postmetas.any? do |meta|
        meta[:meta_key] == 'organizer'.freeze
        meta[:meta_value] == user.id
      end

      is_member?(user)
    end

    # @todo... oh god!
    # WARNING: REQUIRES team_profile_map
    # create view team_profile_map as
    # (select team.post_id as `membership_id`, team.meta_value as `team_id`, profile.meta_value as `profile_id` from wp_postmeta team inner join wp_postmeta profile on team.meta_key = 'team' and profile.meta_key = 'profile' and team.post_id = profile.post_id);
    def is_member?(user)
      # if user's profiles have memeberships for this team
      profile_ids = user.profiles.select(:id).sql

      DB["SELECT 1 FROM team_profile_map WHERE team_id = ? AND profile_id IN (#{ profile_ids }) LIMIT 1", id].any?
    end

    def editable_by?(user)
      return true if created_by_id == user.id

      # @todo: check role

      postmetas.any? do |meta|
        meta[:meta_key] == 'organizer'.freeze
        meta[:meta_value] == user.id
      end
    end

    def deleteable_by?(user)
      created_by_id == user.id
    end

    def save!(hash = {})
      if hash.blank?
        create! unless id.present?
      else
        update(hash)
      end
    end

    def update(hash)
      field_data = hash.slice(*self.class.fields)

      # check for updates?
      # raise ValidationError.new(self) unless valid?
      # update sub-resources?

      super(field_data)
    end

    class << self
      def filter_by_title(title_filter)
        return self unless title_filter.present?

        where(Sequel.like(:post_title, "%#{ title_filter }%"))
      end

      def accessible_to_condition(user)
        condition = Sequel.expr(post_author: user.id)

        organizable_ids = WPDB::PostMeta
          .distinct.select(:post_id)
          .where(meta_key: 'organizer', meta_value: user.id)

        condition |= Sequel.expr(id: organizable_ids)
      end
    end
  end
end
