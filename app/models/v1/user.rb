require_relative 'active_record_sequel_adapter'

module V1
  class User < WPDB::User
    include ActiveRecordSequelAdapter
  end
end
