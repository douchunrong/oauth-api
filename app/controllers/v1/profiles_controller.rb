require_relative '../../models/v1/profile'
require_relative 'api_controller'

module Controllers
  module V1
    class ProfilesController < ApiController
      self.model_class = Models::V1::Profile

      private

      def append_title_filter!(query, name)
        query.where!(id: Models::V1::Profile.with_profile_data(name))
      end
    end
  end
end
