require_relative 'pods_model'
require_relative 'checkin'
require_relative 'location'
require_relative 'resource_organizer'
require_relative 'sport'
require_relative 'waiver'

module Models::V1
  class Event < PodsModel
    include DataExposureMethods

    pods_type('sprtid_event')

    initialize_common_pods_methods!

    metafield :type, :event_type
    metafield :begins_at, :event_start, type: DateTime
    metafield :ends_at, :event_end, type: DateTime
    metafield :sport_id, :sport

    many_to_one :created_by, {
      key: :post_author,
      primary_key: :ID,
      class: 'Models::V1::User'
    }

    def checkins
      checkin_ids = WPDB::PostMeta
        .where(meta_key: 'event'.freeze, meta_value: id)
        .map { |m| m[:post_id] }
        .uniq

      Checkin.find(checkin_ids).all
    end

    many_to_many :locations, {
      right_key: :location_id,
      left_key: :object_id,
      join_table: "#{WPDB.prefix}geo_mashup_location_relationships",
      class: 'Models::V1::Location'
    }

    # one_to_one :logo, {
    #   key: :ID,
    #   primary_key: :logo,
    #   class: 'Models::V1::Image'
    # }
    def logo
      Image.find(meta_value(:logo))
    end

    def organizers
      EventOrganizer.for_resource(self)
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
      options[:methods] << :locations
      options[:methods] << :organizers
      options[:methods] << :sport
      options[:methods] << :waiver

      super(options)
    end

    class << self
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
