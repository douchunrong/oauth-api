require_relative 'base'
require_relative 'contact'
require_relative 'event'
require_relative 'team'
require_relative 'profile_datum'

module Models
  module V1
    class Attachment < ActiveRecord::Base
      extend Base

      # attr_accessible :name
      # attr_accessible :description
      # attr_accessible :meta
      # attr_accessible :mime_type

      has_one :contact, inverse_of: :photo
      has_one :event, inverse_of: :logo
      has_one :team, inverse_of: :logo

      # plural hell!
      has_many :profile_data, {
        class_name: 'Models::V1::AttachmentProfileDatum',
        inverse_of: :attachment
      }
    end

    class WordpressAttachment < Attachment
      # attr_accessible :migration_meta
    end

    class ExternalAttachment < Attachment
      # attr_accessible :url
    end

    class ImageAttachment < Attachment
      # attr_accessible :base64
    end
  end
end
