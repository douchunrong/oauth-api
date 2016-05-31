require_relative '../../models/v1/checkin'
require_relative 'application_controller'

module V1
  # @todo: should this even be a controller?
  #        should it rather be a subcontroller of profile and event?
  class CheckinsController < ApplicationController
    respond_to :json

    before_action :doorkeeper_authorize!

    def index
      checkins = Checkin.accessible_to(current_user)

      render(json: checkins)
    end

    def create
      halt(405, 'Not Implemented')
    end

    def show
      resource = Checkin.find(params[:id])

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
