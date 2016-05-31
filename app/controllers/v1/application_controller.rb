require_relative '../application_controller'

module V1
  class ApplicationController < ::ApplicationController
    private

    def current_user
      @current_user ||= User.find(doorkeeper_token.resource_owner_id)
    end
  end
end
