require 'ruby-wpdb'

class PodsModel < WPDB::Post
  dataset_module do
    def active
      filter(post_type: model.post_type)
    end
  end

  def after_initialize
    self.meta_lookup = Hash[
      postmetas.map { |m| [m.meta_key.to_sym, m] }
    ]
  end

  plugin :after_initialize

  def as_json(options = {})
    options = options.try(:clone) || {}

    (options[:except] ||= []).concat self.class.internals
    (options[:methods] ||= []).concat self.class.fields

    # (see comment below) the delegate has String keys, therefore, internal.to_s
    options[:except].map!(&:to_s)

    # at some point in the inheritance tree, there is a simple delegator,
    # which delegates to a hash.  Instead of calling as_json with the options
    # on that hash, it simply returns the hash.
    # on that note, *we* call as_json on that hash, but then have to apply
    # methods manually, since we want the methods sent to this instance, not
    # the underlying hash
    super
      .as_json(options)
      .tap do |hash|
        options[:methods].each { |f| hash[f] = send(f) }
      end
  end

  private

  attr_accessor :meta_lookup
  cattr_accessor :fields, :internals

  class << self
    attr_reader :post_type

    def find(id)
      queryable_for_find(id).first
    end

    def queryable_for_find(id)
      where(id: id).limit(1)
    end

    protected

    attr_writer :post_type

    def pods_type(type)
      self.post_type = type

      # roughly equivalent to ActiveRecord default_scope
      # called here to ensure that post_type is set
      set_dataset(active)
    end

    def ignore(*internals)
      (self.internals ||= []).concat internals
    end

    def alias_method(accessor, internal)
      (self.internals ||= []) << internal.to_s
      (self.fields ||= []) << accessor

      super
    end

    def field(accessor, meta_key = nil)
      (self.fields ||= []) << accessor
      meta_key ||= accessor

      class_eval %Q{
        def #{ accessor }
          meta_lookup[:#{ meta_key }].try(:meta_value)
        end

        def #{ accessor }=(val)
          meta_lookup[:#{ meta_key }].try(:meta_value=, val)
        end
      }
    end
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
