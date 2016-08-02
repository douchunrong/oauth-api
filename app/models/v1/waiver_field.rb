require_relative 'base'
require_relative 'waiver'
require_relative 'profile_data_type'

module Models
  module V1
    class WaiverField < ActiveRecord::Base
      extend Base

      belongs_to :waiver
      belongs_to :profile_data_type

      # attr_accessible :description
    end
  end
end
