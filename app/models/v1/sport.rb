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

      DEFAULT_JSON_FIELDS = %i(id name slug description).freeze

      def serializable_hash(options = {})
        return super if options.present?

        super(only: DEFAULT_JSON_FIELDS)
      end
    end
  end
end
