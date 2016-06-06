require_relative '../../application_controller'

# @todo: should this even be a controller?
#        should it rather be a subcontroller of profile and event?
class Api::V1::ApiController < ApplicationController
  respond_to :json

  before_action :doorkeeper_authorize!

  def index
    render(json: list(params).map(&:as_json))
  end

  def create
    resource = self.class.model_class.create(params)

    not_valid! unless resource.valid?

    resource.save!

    render(json: resource.as_json, status: 201)
  rescue ValidationError => e
    halt(401, e.errors.to_json)
  end

  def show
    resource = self.class.model_class.find(params[:id])

    raise NotFoundError, params[:id] if resource.nil?

    raise PermissionError, :read unless resource.readable_by?(current_user)

    render(json: resource.as_json)
  rescue NotFoundError => e
    not_found!(e.message)
  rescue PermissionError => e
    permission_error!(e.message)
  end

  def update
    resource = self.class.model_class.find(params[:id])

    raise NotFoundError, params[:id] if resource.nil?

    raise PermissionError, :edit unless resource.editable_by?(current_user)

    resource.save!(params)

    render(json: resource.as_json)
  rescue NotFoundError => e
    not_found!(e.message)
  rescue PermissionError => e
    permission_error!(e.message)
  end

  def destroy
    resource = self.class.model_class.find(params[:id])

    raise NotFoundError, params[:id] if resource.nil?

    raise PermissionError, :delete unless resource.deletable_by?(current_user)

    resource.destroy!

    head :no_content
  rescue NotFoundError => e
    not_found!(e.message)
  rescue PermissionError => e
    permission_error!(e.message)
  end

  private

  def fail!(messages, status)
    render(json: { messages: messages }, status: status)
  end

  def not_found!
    fail!([message], 404)
  end

  def permission_error!(message)
    fail!([message], 403)
  end

  def list(params)
    self.class.model_class.fields_filters_pagination_and_sort(params)
      .tap do |query|
        next if current_user.admin?

        query.where!(self.class.model_class.accessible_to(current_user))
      end
  end

  class << self
    attr_accessor :model_class
  end
end
