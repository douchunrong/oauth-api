require_relative 'pods_model'
require_relative 'event'
require_relative 'profile'

class Checkin < PodsModel
  pods_type('sprtid_checkin')

  field :signature

  # many_to_one :initialized_by,
  #   join_table: "#{WPDB.prefix}users"
  #   key: :post_parent,
  #   class: self,
  #   conditions: { post_type: 'attachment' }

  # many_to_one :checked_in_by, join_table: "#{WPDB.prefix}posts"

  many_to_many :profile,
    key: :post_parent,
    class: Profile,
    conditions: { post_type: Profile.post_type }

  many_to_many :event,
    key: :post_parent,
    class: Event,
    conditions: { post_type: Event.post_type }
end
