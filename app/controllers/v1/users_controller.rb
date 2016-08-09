require_relative '../../models/v1/user'
require_relative 'api_controller'

module Controllers
  module V1
    class UsersController < ApiController
      respond_to :json

      def new
        @user = Models::V1::User.new
      end

      def show
        resource = Models::V1::User.find(params[:id])

        render(json: resource)
      end

      private

      def user_params
        # params.require(:user).permit(:email, :password, :password_confirmation)
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
