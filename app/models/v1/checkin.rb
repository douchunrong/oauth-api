require_relative 'access_grant'
require_relative 'place'

module Models
  module V1
    class Checkin
      attr_accessor :access_grant, :event
    end
  end
end
