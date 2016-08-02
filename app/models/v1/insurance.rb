require_relative 'base'
require_relative 'profile_datum'

module Models
  module V1
    class Insurance < ActiveRecord::Base
      extend Base

      # attr_accessible :company_name, :plan_type, :group_number, :phone, :member_number

      # plural hell!
      has_many :profile_data, {
        class_name: 'Models::V1::InsuranceProfileDatum',
        inverse_of: :insurance
      }
    end
  end
end