require_relative '../../../models/v1/team'
require_relative 'api_controller'

class Api::V1::TeamsController < Api::V1::ApiController
  self.model_class = Models::V1::Team
end
