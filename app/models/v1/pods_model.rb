require 'ruby-wpdb'

require_relative 'active_record_sequel_adapter'
require_relative 'data_exposure_methods'

# ******* 'I have no idea what Im doing' *******
# I want this to live somewhere else, but it's super fickle.  The class
# WPDB::Post doesn't exist until WPDB.init is invoked, so it lives here to be
# sure that it executes before creating these classes
config = Rails.configuration.database_configuration
host = config[Rails.env]['host']
database = config[Rails.env]['database']
username = config[Rails.env]['username']
password = config[Rails.env]['password']
socket = config[Rails.env]['socket']

database_uri = "mysql2://#{ username }:#{ password }@#{ host }/#{ database }"
database_uri += "?socket=#{ socket }" if socket.present?

WPDB.init(database_uri)
# ******* END 'I have no idea what Im doing' *******

module Models::V1
  class PodsModel < WPDB::Post
    include ActiveRecordSequelAdapter

    attr_accessor :meta_lookup

    def after_initialize
      self.meta_lookup = Hash[
        postmetas.map { |m| [m.meta_key.to_sym, m] }
      ]
    end

    plugin(:after_initialize)

    dataset_module do
      # there is some fucking magic in here
      def active
        post_type = model.post_type

        where{
          Sequel.&(
            Sequel.~(post_status: Status::DELETED),
            { post_type: post_type }
          )
        }
      end
    end

    module Status
      DELETED = 'trash'.freeze
      DRAFT = 'draft'.freeze
      PUBLISHED = 'publish'.freeze
    end

    def destroy!
      update(post_status: Status::DELETED)
    end

    class << self
      attr_reader :post_type

      def accessible_to_condition(user)
        raise NotImplementedError
      end

      def fields_filters_pagination_and_sort(params)
        params ||= {}
        fields = (params[:fields] || '')
          .split(',')
          .map(&:strip)
          .reject(&:blank?)

        select(*fields).tap do |query|
          apply_filters!(query, params[:filters])
          apply_pagination!(query, params[:pagination])
          apply_sort!(query, params[:order_by])
        end
      end

      protected

      def pods_type(type)
        self.post_type = type

        # roughly equivalent to ActiveRecord default_scope
        # called here to ensure that post_type is set
        set_dataset(active)
      end

      def apply_filters!(query, filters)
        filters ||= {}

        clause = Sequel.expr(
          post_status: filters[:status] || Status::PUBLISHED
        )

        if filters[:title].present?
          clause |= Sequel.like(:post_title, "%#{ filters[:title] }%")
        end

        query.where!(clause)
      end

      def apply_pagination!(query, options)
        options ||= {}

        limit = options[:limit].to_i
        limit = 10 if limit.zero?

        page = options[:page].to_i
        page = 1 if page.zero?

        offset = (page - 1) * limit

        query.limit!(limit).offset!(offset)
      end

      # @todo: allow fields to be an array
      def apply_sort!(query, fields)
        # @todo: allow filters to be on nicenames, not wordpress column names
        # i.e., title, not post_title
        fields ||= :post_title

        order =
          if fields =~ /^-/
            Sequel.desc(fields[1..-1])
          else
            Sequel.asc(fields)
          end

        query.order!(order)
      end

      private

      attr_writer :post_type

      def initialize_common_pods_methods!
        field :createdById, :post_author
        field :createdAt, :post_date, type: DateTime
        field :id, :ID
        field :modifiedAt, :post_modified, type: DateTime
        field :name, :post_name
        field :parent, :post_parent
        field :status, :post_status
        field :title, :post_title

        ignore \
          :comment_count,
          :comment_status,
          :guid,
          :menu_order,
          :ping_status,
          :pinged,
          :post_content,
          :post_content_filtered,
          :post_date_gmt,
          :post_excerpt,
          :post_mime_type,
          :post_modified_gmt,
          :post_password,
          :post_type,
          :to_ping
      end
    end
  end
end
