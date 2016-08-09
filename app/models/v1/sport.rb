require_relative 'base'
require_relative 'place'
require_relative 'group'

module Models
  module V1
    # @todo: s/slug/name, s/name/label
    class Sport < ActiveRecord::Base
      extend Base

      # attr_accessible :slug, :name, :description
      has_many :places
      has_many :groups
    end
  end
end
