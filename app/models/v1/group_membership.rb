require_relative 'base'
require_relative 'group'
require_relative 'profile'
require_relative 'user'

module Models
  module V1
    class GroupMembership < ActiveRecord::Base
      extend Base

      belongs_to :group
      belongs_to :profile

      # attr_accessible :uniform_number, :position
      belongs_to :accepted_by, class_name: 'Models::V1::User'
      # attr_accessible :accepted_at
      belongs_to :approved_by, class_name: 'Models::V1::User'
      # attr_accessible :approved_at
    end
  end
end
