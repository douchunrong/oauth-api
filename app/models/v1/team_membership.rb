require_relative 'base'
require_relative 'team'
require_relative 'profile'
require_relative 'user'

module Models
  module V1
    class TeamMembership < ActiveRecord::Base
      extend Base

      belongs_to :team
      belongs_to :profile

      # attr_accessible :uniform_number, :position
      belongs_to :accepted_by, class_name: 'Models::V1::User'
      # attr_accessible :accepted_at
      belongs_to :approved_by, class_name: 'Models::V1::User'
      # attr_accessible :approved_at
    end
  end
end
