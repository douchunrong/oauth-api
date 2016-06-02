require_relative '../models/v1/user'
require_relative 'application_controller'

class SessionsController < ApplicationController
  def new
    session[:redirect_uri] = params[:redirect_uri]

    @user = user_class.new.tap do |user|
      user.email = params[:username]
    end
  end

  def create
    @user = user_class.find_by_email(params[:email])

    if @user && @user.authenticate(params[:password])
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
