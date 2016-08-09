require_relative '../../models/v1/group'
require_relative 'api_controller'

module Controllers
  module V1
    class GroupsController < ApiController
      self.model_class = Models::V1::Group
    end
  end
end
