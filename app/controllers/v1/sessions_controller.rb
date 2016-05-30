require_relative '../../models/v1/user'
require_relative 'application_controller'

module V1
  class SessionsController < ApplicationController
    def new
    end

    def create
      @user = User.find_by_email(params[:email])

      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        flash[:success] = 'Welcome back!'
        redirect_to root_path
      else
        flash[:warning] = 'You have entered incorrect email and/or password.'
        render :new
      end
    end

    def destroy
      session.delete(:user_id)
      redirect_to root_path
    end
  end
end
