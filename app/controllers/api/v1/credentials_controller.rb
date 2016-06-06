require_relative 'api_controller'

class Api::V1::CredentialsController < Api::V1::ApiController
  def me
    respond_with current_user
  end
end
