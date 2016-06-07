require_relative '../../../models/v1/sport'
require_relative 'api_controller'

class Api::V1::SportsController < Api::V1::ApiController
  def index
    title = params[:filters].try(:[], :title)

    resources = Models::V1::Sport.filter_by_title(title).all

    render(json: resources)
  end

  def create
    halt(405, 'Not Implemented')
  end

  def show
    resource = Models::V1::Sport.find(params[:id])

    render(json: resource.as_json)
  end

  def update
    halt(405, 'Not Implemented')
  end

  def destroy
    halt(405, 'Not Implemented')
  end
end