# require_relative 'base'

module Models
  module V1
    module Base
      module InstanceMethods
        def serializable_hash(options = {})
          options ||= {}

          excepts = [options[:except]].flatten +
            %i(deleted_at migration_id).freeze

          super(options.merge(except: excepts))
        end
      end

      class << self
        def extended(base)
          base.include(InstanceMethods)

          base.table_name_prefix = 'v1_'
          base.primary_key = 'id' # @todo: is this necessary?

          # base.attr_accessible :id
          base.belongs_to :created_by, class_name: 'Models::V1::User'
          # base.attr_accessible :created_at
          # base.attr_accessible :modified_at
          # base.attr_accessible :deleted_at

          base.send :default_scope, ->{ base.where(deleted_at: nil) }
        end

        def columns
          super.reject { |c| c.name == 'migration_id' }
        end

        def accessible_to(user)
          all
        end
      end
    end
  end
end
