require_relative '../../models/v1/user'
require_relative 'application_controller'

module V1
  class UsersController < ApplicationController
    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        session[:user_id] = @user.id
        flash[:success] = 'Welcome!'
        redirect_to root_path # but probably to return_url?
      else
        render :new
      end
    end

    private

    def user_params
      # params.require(:user).permit(:email, :password, :password_confirmation)
      params.require(:user).permit(:email, :password)
    end
  end
end
