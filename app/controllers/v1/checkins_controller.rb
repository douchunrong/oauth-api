require_relative '../../models/v1/checkin'

module V1
  class CheckinsController < ApplicationController
    def index
      [405, 'Not Implemented']
    end

    def create
      [405, 'Not Implemented']
    end

    def new
      [405, 'Not Implemented']
    end

    def edit
      [405, 'Not Implemented']
    end

    def show
      resource = Checkin.find(params[:id])

      render(json: resource.as_json)
    end

    def update
      [405, 'Not Implemented']
    end

    def destroy
      [405, 'Not Implemented']
    end
  end
end
