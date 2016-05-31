require_relative '../../models/v1/checkin'
require_relative 'application_controller'

module V1
  class CheckinsController < ApplicationController
    respond_to :json

    before_action :doorkeeper_authorize!

    def index
      render(json: current_user.checkins)
    end

    def create
      halt(405, 'Not Implemented')
    end

    def new
      halt(405, 'Not Implemented')
    end

    def edit
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
