require_relative '../../models/v1/event'
require_relative 'application_controller'

module V1
  class EventsController < ApplicationController
    respond_to :json

    before_action :doorkeeper_authorize!

    def index
      title = params[:filters].try(:[], :title)

      events = if current_user.admin?
        Event.filter_by_title(title).all
      else
        Event.accessible_to(current_user, title)
      end

      render(json: events)
    end

    def create
      halt(405, 'Not Implemented')
    end

    def show
      resource = Event.find(params[:id])

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
