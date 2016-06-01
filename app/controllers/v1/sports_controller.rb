require_relative '../../models/v1/sport'
require_relative 'application_controller'

module V1
  class SportsController < ApplicationController
    respond_to :json

    before_action :doorkeeper_authorize!

    def index
      title = params[:filters].try(:[], :title)

      resources = if current_user.admin?
        Sport.filter_by_title(title).all
      else
        Sport.accessible_to(current_user, title)
      end

      render(json: resources)
    end

    def create
      halt(405, 'Not Implemented')
    end

    def show
      resource = Sport.find(params[:id])

      render(json: resource.as_json)
    end

    def update
      halt(405, 'Not Implemented')
    end

    def destroy
      halt(405, 'Not Implemented')
    end
  end
end
