# require_relative 'base'

module Models
  module V1
    module Base
      module InstanceMethods
        def createable_by?(user, params = {})
          user.present?
        end

        def readable_by?(user)
          return false if user.nil?

          created_by_id == user.id
        end

        def updateable_by?(user, params = {})
          return false if user.nil?

          created_by_id == user.id
        end

        def deletable_by?(user)
          return false if user.nil?

          created_by_id == user.id
        end

        def serializable_hash(options = {})
          options ||= {}

          excepts = [options[:except]].flatten +
            %i(deleted_at migration_id).freeze

          super(options.merge(except: excepts))
        end
      end

      def self.extended(base)
        base.include(InstanceMethods)

        base.table_name_prefix = 'v1_'
        base.primary_key = 'id' # @todo: is this necessary?

        # base.attr_accessible :id
        base.belongs_to :created_by, class_name: 'Models::V1::User'
        # base.attr_accessible :created_at
        # base.attr_accessible :modified_at
        # base.attr_accessible :deleted_at

        base.send :acts_as_paranoid
        # base.send :default_scope, ->{ base.where(deleted_at: nil) }
      end

      def timestamp_attributes_for_update
        super << :modified_at
      end

      def timestamp_attributes_for_create
        super << :modified_at
      end

      def columns
        super.reject { |c| c.name == 'migration_id' }
      end

      def column_keys
        columns.map(&:name)
      end

      def accessible_to(user)
        all
      end

      def inflate(models, key)
        key_id = :"#{ key }_id"

        ids = models.map { |m| m.try(key_id) }.uniq.compact

        resources = find(ids).map { |r| [r.id, r] }.to_h

        models
          .select { |m| m.respond_to?(:"#{ key }=") }
          .each do |model|
            model.send(:"#{ key }=", resources[model.send(key_id)])
          end
      end
    end
  end
end
