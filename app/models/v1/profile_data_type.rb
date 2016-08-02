require_relative 'base'
require_relative 'scope'
require_relative 'profile_datum'
require_relative 'waiver'

module Models
  module V1
    class ProfileDataType < ActiveRecord::Base
      extend Base

      belongs_to :scope

      # attr_accessible :name, :description, :singular, :data_type, :label
      has_many :profile_data
      has_many :waivers, through: :waiver_field
    end
  end
end
