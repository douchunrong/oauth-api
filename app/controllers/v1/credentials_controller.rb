require_relative 'api_controller'

module Controllers
  module V1
    class CredentialsController < ApiController
      def me
        respond_with current_user
      end
    end
  end
end
