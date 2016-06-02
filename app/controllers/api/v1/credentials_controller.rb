require_relative 'api_controller'

class Api::V1::CredentialsController < Api::V1::ApiController
  def me
Rails.logger.error(doorkeeper_token.to_json)

    respond_with current_user
  end
end
