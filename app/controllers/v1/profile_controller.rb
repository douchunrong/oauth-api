require_relative '../../models/v1/profile'
require_relative 'application_controller'

module V1
  class ProfilesController < ApplicationController
    respond_to :json

    before_action :doorkeeper_authorize!

    def index
      title = params[:filters].try(:[], :title)

      resources = if current_user.admin?
        Profile.filter_by_title(title).all
      else
        Profile.accessible_to(current_user, title)
      end

      render(json: resources)
    end

    def create
      halt(405, 'Not Implemented')
    end

    def show
      resource = Profile.find(params[:id])

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
