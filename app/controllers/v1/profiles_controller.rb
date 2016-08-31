require_relative '../../models/v1/profile'
require_relative '../../models/v1/location'
require_relative '../../models/v1/organizer'
require_relative '../../models/v1/organizer_type'
require_relative '../../models/v1/profile_datum'
require_relative 'api_controller'

module Controllers
  module V1
    class ProfilesController < ApiController
      self.model_class = Models::V1::Profile

      # Profiles are collections of other data and have no properties of their own!
      def create
        resource = self.class.model_class.new(created_by: current_user)
        resource.created_by = current_user

        not_valid! unless resource.valid?

        resource.save!

        # subsequent calls to /profiles/:profile_id/organizers should handle
        # this, but wthell, let's make sure this profile doesn't get abandoned
        create_organizers!(resource, params[:organizers])

        # create profile data if applicable
        if params[:profile_data]
          resource.profile_data = Models::V1::ProfileDatum
            .from_scoped_hash(params[:profile_data], resource, current_user)
        end

        render(json: resource.as_json(include: :profile_data), status: 201)
      rescue ActiveRecord::RecordInvalid => e
        halt(401, e.errors.to_json)
      end

      def list(*)
        super.reject { |p| p.user_id == current_user_id }
      end

      private

      def append_title_filter!(query, name)
        query.where!(id: Models::V1::Profile.with_profile_data(name))
      end

      def create_organizers!(resource, organizers_form_data)
        return if organizers_form_data.blank?

        # @todo: allow for multipls (punted because I didn't want to handle multiple default organizers)
        form_data = organizers_form_data.first

        return if form_data.blank?

        organizer_type_id = form_data[:organizer_type_id]

        organizer_type_id ||= Models::V1::OrganizerType.find_by(
          organizer_type: Models::V1::ProfileOrganizer.name,
          name: 'parent'
        ).id

        resource.organizers << Models::V1::ProfileOrganizer.create(
          created_by: current_user,
          organizer: current_user,
          organizer_type_id: organizer_type_id
        )
      end
    end
  end
end
