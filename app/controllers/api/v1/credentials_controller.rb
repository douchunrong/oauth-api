require_relative 'api_controller'

class Api::V1::CredentialsController < Api::V1::ApiController
  def me
    respond_with current_user.tap { |me| p '8'*100, me }
  end
end
