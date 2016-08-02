require_relative 'base'
require_relative 'profile_data_type'

module Models
  module V1
    class Scope < ActiveRecord::Base
      extend Base

      # attr_accessible :name, :description, :label

      has_many :profile_data_types
    end
  end
end
