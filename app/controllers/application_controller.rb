class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  # @todo: sort this out once there's a V2
  def current_user
    @current_user ||= V1::User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user
end
