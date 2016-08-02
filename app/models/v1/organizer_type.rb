require_relative 'base'

module Models
  module V1
    class OrganizerType < ActiveRecord::Base
      extend Base

      # attr_accessible :type, :value, :label
      # attr_accessible :default_can_edit, :default_can_add_organizer
    end
  end
end
