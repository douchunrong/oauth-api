require_relative '../../models/v1/organization'
require_relative 'api_controller'

module Controllers
  module V1
    class OrganizationsController < ApiController
      self.model_class = Models::V1::Organization
      self.resource_param = :organization
    end
  end
end
