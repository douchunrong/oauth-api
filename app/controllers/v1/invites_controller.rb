require_relative '../../models/v1/attachment'
require_relative '../../models/v1/invite'
require_relative 'api_controller'

module Controllers
  module V1
    class InvitesController < ApiController
      self.model_class = Models::V1::Invite

      private

      def list(params)
        super.tap do |models|
          resources = models.map(&:resource)

          Models::V1::Attachment.inflate(resources, :logo)
        end
      end
    end
  end
end
