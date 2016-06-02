require_relative '../../../models/v1/profile'
require_relative 'api_controller'

class Api::V1::ProfilesController < Api::V1::ApiController
  def index
    title = params[:filters].try(:[], :title)

    resources = if current_user.admin?
      Models::V1::Profile.filter_by_title(title).all
    else
      Models::V1::Profile.accessible_to(current_user, title)
    end

    render(json: resources)
  end

  def create
    halt(405, 'Not Implemented')
  end

  def show
    resource = Models::V1::Profile.find(params[:id])

    render(json: resource.as_json)
  end

  def update
    halt(405, 'Not Implemented')
  end

  def destroy
    halt(405, 'Not Implemented')
  end
end
