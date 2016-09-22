module Service
  module V1
    class UserResourceView
      attr_accessor :resource, :user

      def initialize(resource, user)
        self.resource = resource
        self.user = user
      end

      def as_json(options = {})
        resource.as_json(options).tap do |hash|
          hash[:meta] = {}

          if resource.respond_to?(:readable_by?)
            hash[:meta][:can_read] = resource.readable_by?(user)
          end

          if resource.respond_to?(:updateable_by?)
            hash[:meta][:can_update] = resource.updateable_by?(user)
          end

          if resource.respond_to?(:deletable_by?)
            hash[:meta][:can_delete] = resource.deletable_by?(user)
          end
        end
      end

      class << self
        def factory(resource, user)
          # case(resource)
          # when Models::V1::Place
          #   UserPlaceView.new(resource, user)
          # else
            new(resource, user)
          # end
        end
      end
    end

    # class UserPlaceView < UserResourceView
    #   def as_json(options = {})
    #     super.tap do |hash|
    #       hash[:meta][:checkins] = checkins
    #     end
    #   end

    #   def checkins
    #     # event organizer? checked in users
    #     # profile checked into this event?
    #     []
    #   end
    # end
  end
end
