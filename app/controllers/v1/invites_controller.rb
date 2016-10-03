require_relative '../../models/v1/attachment'
require_relative '../../models/v1/invite'
require_relative 'api_controller'

module Controllers
  module V1
    class InvitesController < ApiController
      self.model_class = Models::V1::Invite
      self.resource_param = :invite

      protected

      def list_resources(params, includes = nil)
        super.tap do |models|
          resources = models.map(&:resource)

          # where you at ActiveModel Serializers??
          Models::V1::Attachment.inflate(resources, :logo)
        end
      end
    end
  end
end
