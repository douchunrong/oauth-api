require_relative '../models/v1/user'
require_relative 'application_controller'

class SessionsController < ApplicationController
  def new
    @user = user_class.new.tap do |user|
      user.email = params[:username]
    end
  end

  def create
    @user = user_class.authenticate(params[:email], params[:password])

    if @user.present?
      session[:user_id] = @user.id
      redirect_to(session[:redirect_uri] || root_url, notice: 'Logged in!')
      session.delete(:redirect_uri)
    else
      flash[:warning] = 'You have entered incorrect email and/or password.'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end

  def user_class
    Models::V1::User
  end
end
