require 'ruby-wpdb'

config = Rails.configuration.database_configuration
host = config[Rails.env]['host']
database = config[Rails.env]['database']
username = config[Rails.env]['username']
password = config[Rails.env]['password']
socket = config[Rails.env]['socket']

WPDB.init("mysql2://#{ username }:#{ password }@#{ host }/#{ database }?socket=#{ socket }")

module V1
  class CheckinsController < ApplicationController
    def index
      resources = WPDB::Post
        .where(post_type: 'sprtid_checkin')
        .reverse_order(:post_date)
        .limit(5)
        .all

      render json: resources
    end

    def create
      render json: {}
    end

    def new
      render json: {}
    end

    def edit
      render json: {}
    end

    def show
      render json: {}
    end

    def update
      render json: {}
    end

    def destroy
      render json: {}
    end
  end
end
