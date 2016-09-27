require_relative '../../models/v1/division'
require_relative 'api_controller'

module Controllers
  module V1
    class DivisionsController < ApiController
      self.model_class = Models::V1::Division
      self.resource_param = :division
    end
  end
end
