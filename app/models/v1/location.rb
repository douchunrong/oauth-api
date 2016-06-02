module Models::V1
  Address = Struct.new(:street, :unit, :city, :state, :zip)

  class Location < Sequel::Model(:"#{WPDB.prefix}geo_mashup_locations")
    def coordinates
      [lat, lng]
    end

    def as_json(options = {})
      options = options.try(:clone) || {}

      (options[:except] ||= []) << :lat << :lng
      (options[:methods] ||= []) << :coordinates

      super(options)
    end

    class << self
      def from_address(address)
        full_address = [
          address.street,
          address.unit,
          "#{ address.city }, #{ address.state }",
          address.zip
        ].compact.join(' ')
        postal_code = address.zip
        country_code = 'US'

        new({
          address: full_address,
          postal_code: postal_code,
          country_code: country_code
        })
      end
    end
  end
end
