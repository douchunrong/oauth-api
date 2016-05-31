require_relative 'pods_model'
require_relative 'image'
require_relative 'location'
require_relative 'resource_organizer'
require_relative 'sport'
require_relative 'waiver'

module V1
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
      class: 'V1::User'
    }

    # one_to_one :logo, {
    #   key: :ID,
    #   primary_key: :logo,
    #   class: 'V1::Image'
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
      PHP.unserialize meta_value(:_wp_attachment_metadata)
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
      options[:methods] << :addresses
      options[:methods] << :external_ids
      options[:methods] << :locations
      options[:methods] << :logo
      options[:methods] << :metadata
      options[:methods] << :organizers
      options[:methods] << :sport
      options[:methods] << :waiver

      super(options)
    end

    class << self
      def filter_by_title(title_filter)
        return self unless title_filter.present?

        where(Sequel.like(:post_title, "%#{ title_filter }%"))
      end

      def accessible_to(user, title_filter = nil)
        condition = Sequel.expr(post_author: user.id)

        organizable_ids = WPDB::PostMeta
          .distinct.select(:post_id)
          .where(meta_key: 'organizer', meta_value: user.id)

        condition |= Sequel.expr(id: organizable_ids)

        filter_by_title(title_filter)
          .where(condition)
          .all
      end
    end
  end
end
