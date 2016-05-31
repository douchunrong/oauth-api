module V1
  module DataExposureMethods
    def self.included(base)
      base.send(:cattr_accessor, :fields, :internals)

      base.extend(ClassMethods)
    end

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

    def typed_value(value, type)
      return value unless type.respond_to?(:==)
      return value unless value.is_a?(String)

      case
      when type == DateTime
        DateTime.parse(value)
      else
        value
      end
    end

    def meta_value(key, type = nil)
      typed_value(meta_lookup[key].try(:meta_value), type)
    end

    module ClassMethods
      def ignore(*internals)
        (self.internals ||= []).concat internals
      end

      def field(accessor, internal, options = {})
        (self.internals ||= []) << internal.to_s
        (self.fields ||= []) << accessor

        # self.alias_method(accessor, internal)
        class_eval %Q{
          def #{ accessor }
            typed_value(values[:#{ internal }], #{ options[:type].try(:name) || 'nil' })
          end

          def #{ accessor }=(val)
            values[:#{ internal }] = val
          end
        }
      end

      def metafield(accessor, meta_key = nil, options = {})
        (self.fields ||= []) << accessor
        meta_key ||= accessor

        class_eval %Q{
          def #{ accessor }
            meta_value(:#{ meta_key }, #{ options[:type].try(:name) || 'nil' })
          end

          def #{ accessor }=(val)
            meta_lookup[:#{ meta_key }].try(:meta_value=, val)
          end
        }
      end
    end
  end
end
