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

module V1
  class PodsModel < WPDB::Post
    include ActiveRecordSequelAdapter
    include DataExposureMethods

    attr_accessor :meta_lookup

    def after_initialize
      self.meta_lookup = Hash[
        postmetas.map { |m| [m.meta_key.to_sym, m] }
      ]
    end

    plugin(:after_initialize)

    dataset_module do
      def active
        filter(post_type: model.post_type)
      end
    end

    class << self
      attr_reader :post_type

      protected

      def pods_type(type)
        self.post_type = type

        # roughly equivalent to ActiveRecord default_scope
        # called here to ensure that post_type is set
        set_dataset(active)
      end

      private

      attr_writer :post_type
    end

    alias_method :createdBy, :post_author
    alias_method :createdAt, :post_date
    alias_method :id, :ID
    alias_method :modifiedAt, :post_modified
    alias_method :name, :post_name
    alias_method :parent, :post_parent
    alias_method :status, :post_status
    alias_method :title, :post_title

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
