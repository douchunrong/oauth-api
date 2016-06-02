require_relative '../../../models/v1/event'
require_relative 'api_controller'

class Api::V1::EventsController < Api::V1::ApiController
  def index
    title = params[:filters].try(:[], :title)

    resources = if current_user.admin?
      Models::V1::Event.filter_by_title(title).all
    else
      Models::V1::Event.accessible_to(current_user, title)
    end

    render(json: resources)
  end

  def create
    halt(405, 'Not Implemented')
  end

  def show
    resource = Models::V1::Event.find(params[:id])

    render(json: resource.as_json)
  end

  def update
    halt(405, 'Not Implemented')
  end

  def destroy
    halt(405, 'Not Implemented')
  end
end
