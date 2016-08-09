require_relative '../../models/v1/invite'
require_relative 'api_controller'

module Controllers
  module V1
    class InvitesController < ApiController
      self.model_class = Models::V1::Invite
    end
  end
end
