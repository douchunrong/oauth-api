require_relative 'base'
require_relative 'event'
require_relative 'team'

module Models
  module V1
    # @todo: s/slug/name, s/name/label
    class Sport < ActiveRecord::Base
      extend Base

      # attr_accessible :slug, :name, :description
      has_many :events
      has_many :teams
    end
  end
end
