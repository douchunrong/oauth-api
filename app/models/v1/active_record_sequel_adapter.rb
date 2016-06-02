module Models
  module V1
    module ActiveRecordSequelAdapter
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      module ClassMethods
        # id may be an array
        def find(id)
          queryable_for_find(id).first
        end

        def queryable_for_find(id)
          where(id: id).limit(1)
        end
      end
    end
  end
end
