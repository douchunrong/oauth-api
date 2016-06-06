require_relative '../../../models/v1/event'
require_relative 'api_controller'

class Api::V1::EventsController < Api::V1::ApiController
  self.model_class = Models::V1::Event
end
