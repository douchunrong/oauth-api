require_relative 'base'
require_relative 'resource_external_source'

module Models
  module V1
    class ExternalSource < ActiveRecord::Base
      extend Base

      # attr_accessible :name, :description, :website, :label

      # don't remember why I put this here
      # belongs_to :organization

      has_many :resource_external_sources
    end
  end
end
