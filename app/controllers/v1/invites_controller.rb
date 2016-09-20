require_relative '../../models/v1/attachment'
require_relative '../../models/v1/invite'
require_relative 'api_controller'

module Controllers
  module V1
    class InvitesController < ApiController
      self.model_class = Models::V1::Invite

      ACCEPTED_STATE = 'accepted'.freeze
      REJECTED_STATE = 'rejected'.freeze

      protected

      def resource_params
        request.POST[:invite].dup
          .tap do |params|
            # params[:state] will not be included in the params[:invite]
            # because it is not an attribute of Invite, rather a piece
            # of the Invite API
            state = request.POST[:state]

            case state
            when ACCEPTED_STATE
              params[:accepted_at] = DateTime.now
              params[:accepted_by_id] = current_user_id
            when REJECTED_STATE
              params[:rejected_at] = DateTime.now
              params[:rejected_by_id] = current_user_id
            end
          end
      end

      private

      def list(params, includes = nil)
        super.tap do |models|
          resources = models.map(&:resource)

          Models::V1::Attachment.inflate(resources, :logo)
        end
      end
    end
  end
end
