require_relative 'base'
require_relative 'attachment'
require_relative 'profile_datum'

module Models
  module V1
    class Contact < ActiveRecord::Base
      extend Base

      # attr_accessible :name, :email, :phone, :relationship

      belongs_to :photo, class_name: 'Models::V1::Attachment'

      # plural hell!
      has_many :profile_data, {
        class_name: 'Models::V1::ContactProfileDatum',
        inverse_of: :contact
      }
    end
  end
end
