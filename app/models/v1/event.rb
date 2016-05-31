require_relative 'pods_model'
require_relative 'checkin'
require_relative 'sport'
require_relative 'waiver'

module V1
  class Event < PodsModel
    include DataExposureMethods

    pods_type('sprtid_event')

    initialize_common_pods_methods!

    field :type, :event_type
    field :begins_at, :event_start
    field :ends_at, :event_end
    field :sport_id, :sport

    many_to_one :created_by, {
      key: :post_author,
      primary_key: :ID,
      class: 'V1::User'
    }

    def waiver
      [Waiver.new(meta_value(:terms), nil)]
    end

    def sport
      Sport.find(sport_id)
    end

    def checkins
      checkin_ids = WPDB::PostMeta
        .where(meta_key: 'event'.freeze, meta_value: id)
        .map { |m| m[:post_id] }
        .uniq

      Checkin.find(checkin_ids).all
    end

    def as_json(options = {})
      options = options.try(:clone) || {}

      (options[:methods] ||= []) << :waiver << :sport

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
