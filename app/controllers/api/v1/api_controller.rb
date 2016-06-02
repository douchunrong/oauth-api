require_relative '../../application_controller'

# @todo: should this even be a controller?
#        should it rather be a subcontroller of profile and event?
class Api::V1::ApiController < ApplicationController
  respond_to :json

  before_action :doorkeeper_authorize!
end
