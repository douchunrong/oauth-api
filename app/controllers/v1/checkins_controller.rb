require_relative '../../models/v1/checkin'
require_relative 'api_controller'

# @todo: should this even be a controller?
#        should it rather be a subcontroller of profile and event?
module Controllers
  module V1
    class CheckinsController < ApiController
      def index
        checkins = Models::V1::Checkin.accessible_to(current_user)

        render(json: checkins)
      end

      def create
        halt(405, 'Not Implemented')
      end

      def show
        resource = Models::V1::Checkin.find(params[:id])

        render \
          json: Service::V1::UserResourceView
            .factory(resource, current_user)
            .as_json
      end

      def update
        halt(405, 'Not Implemented')
      end

      def destroy
        halt(405, 'Not Implemented')
      end
    end
  end
end
