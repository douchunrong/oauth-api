require_relative 'base'

module Models
  module V1
    class OrganizerType < ActiveRecord::Base
      extend Base

      # attr_accessible :type, :value, :label
      # attr_accessible :default_can_edit, :default_can_add_organizer

      DEFAULT_JSON_FIELDS = %i(id name label).freeze

      def serializable_hash(options = {})
        return super if options.present?

        super(only: DEFAULT_JSON_FIELDS)
      end
    end
  end
end
