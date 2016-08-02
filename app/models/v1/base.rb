# require_relative 'base'

module Models
  module V1
    module Base
      class << self
        def extended(base)
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
p 'v'*100, __FILE__, __LINE__
          all
        end
      end
    end
  end
end
