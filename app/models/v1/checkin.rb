require_relative 'pods_model'
require_relative 'event'
require_relative 'profile'
require_relative 'user'

module Models::V1
  class Checkin < PodsModel
    include DataExposureMethods

    pods_type('sprtid_checkin')

    initialize_common_pods_methods!

    metafield :signature
    metafield :profile_id, :profile
    metafield :event_id, :event

    many_to_one :created_by, {
      key: :post_author,
      primary_key: :ID,
      class: 'V1::User'
    }

    def checked_in_by
      # in future versions, I expect this to always be the parent, whereas
      # initialized_by could be a coach "checks his/her whole team in"
      # (quotes, because a parent will always have to fill out the form)
      created_by
    end

    def profile
      Profile.find(profile_id)
    end

    def event
      Event.find(event_id)
    end

    def as_json(options = {})
      options = options.try(:clone) || {}

      (options[:methods] ||= []) << :profile << :event

      super(options)
    end

    class << self
      def accessible_to(user, filter = nil)
        # all checkins for this user, this user's profiles, etc
        user.checkins
      end
    end
  end
end
