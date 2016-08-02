require_relative 'base'
require_relative 'division'
require_relative 'organization'

module Models
  module V1
    class DivisionType < ActiveRecord::Base
      extend Base

      # attr_accessible :name, :description

      belongs_to :organization
      belongs_to :parent, class_name: 'Models::V1::DivisionType'

      has_many :divisions
      has_many :division_types, inverse_of: :parent
    end
  end
end
