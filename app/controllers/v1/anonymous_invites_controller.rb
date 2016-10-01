require_relative '../../models/v1/attachment'
require_relative '../../models/v1/invite'
require_relative 'invites_controller'

module Controllers
  module V1
    class PassPhraseError < StandardError; end

    class AnonymousInvitesController < InvitesController
      self.model_class = Models::V1::Invite

      def show
        super
      rescue PassPhraseError
        validation_error!('Pass Phrase is required')
      end

      protected

      def find(token, includes = nil)
        resource = self.class.model_class
          .tap { |c| c.includes(includes) unless includes.nil? }
          .find_by(user_id: nil, user_email: nil, token: token)

        raise PassPhraseError unless resource.matches?(params[:pass_phrase])

        resource = resource.dup_for_user!(current_user_id)

        # where you at ActiveModel Serializers??
        Models::V1::Attachment.inflate(resource.resource, :logo)

        resource
      end
    end
  end
end
