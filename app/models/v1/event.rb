require_relative 'pods_model'
require_relative 'checkin'

module V1
  class Event < PodsModel
    include DataExposureMethods

    pods_type('sprtid_event')

    initialize_common_pods_methods!

    many_to_many :checkins, {
      key: :event,
      class: 'V1::Checkin'
    }
  end
end
