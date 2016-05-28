# This file is used by Rack-based servers to start the application.

require 'ruby-wpdb'

config = Rails.configuration.database_configuration
host = config[Rails.env]['host']
database = config[Rails.env]['database']
username = config[Rails.env]['username']
password = config[Rails.env]['password']
socket = config[Rails.env]['socket']

database_uri = "mysql2://#{ username }:#{ password }@#{ host }/#{ database }"
database_uri += "?socket=#{ socket }" if socket.present?

WPDB.init(database_uri)

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
