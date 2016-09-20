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

      def datum_type
        class_module, p, class_name = ProfileDatum.name.rpartition('::')

        data_type
          .sub(class_module << p, '') # include the module's trailing ::
          .sub(class_name, '')
      end

      def serializable_hash(options = {})
        options = options.try(:clone) || {}

        (options[:methods] ||= []) << :datum_type

        super(options)
      end

      class << self
        def classname
          name.split('::').last
        end
      end
    end
  end
end
