require_relative 'base'
require_relative 'profile'
require_relative 'organization'

module Models
  module V1
    class OrganizationNumber < ActiveRecord::Base
      extend Base

      belongs_to :profile
      belongs_to :organization

      # attr_accessible :number
    end
  end
end
