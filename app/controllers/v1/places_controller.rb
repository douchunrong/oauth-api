require_relative '../../models/v1/place'
require_relative 'api_controller'

module Controllers
  module V1
    class PlacesController < ApiController
      self.model_class = Models::V1::Place
    end
  end
end
