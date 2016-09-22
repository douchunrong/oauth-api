require_relative '../../models/v1/profile'
require_relative '../../models/v1/profile_datum'
require_relative 'api_controller'

module Controllers
  module V1
    class OrganizersController < ApiController
      self.model_class = Models::V1::Organizer

    end
  end
end
