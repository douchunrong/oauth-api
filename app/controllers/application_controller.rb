require_relative '../models/v1/user'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_user
    return unless doorkeeper_token

    user_model_class.find(doorkeeper_token.resource_owner_id)
  rescue => e
    nil
  end

  def user_model_class
    Models::V1::User
  end

  helper_method :current_user
end
