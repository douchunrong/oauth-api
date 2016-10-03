require_relative '../../models/v1/profile'
require_relative '../../models/v1/profile_datum'
require_relative 'api_controller'

module Controllers
  module V1
    # this controller is going to be a beast.
    # you may have access to a profile, but only a subset of it's data
    # depending on your role vs the Profile (e.g., a Parent), vs the Groups
    # (e.g., a Team Coach), vs the Places (e.g., an Event Host) to which
    # the user is checked into.
    #
    # "What am I am organizer for?"
    # "do any of those organized entities have access to this profile?"
    # "what are the scopes my access permits me to read?"
    class ProfileDataController < ApiController
      self.model_class = Models::V1::ProfileDatum

      def index
        profile_data = list(params)

        scope_names = [params[:scope_name]].flatten

        scoped_profile_data =
          Models::V1::Profile.serialized_scoped_data(profile_data, scope_names)

        render(json: scoped_profile_data)
      end

      def create
        profile = Models::V1::Profile.find(params[:profile_id])

        unless profile.updateable_by?(current_user, resource_params)
          permission_error!('You may not view this profile')
        end

        resources = Models::V1::ProfileDatum.from_request_hashes(
          resource_params,
          profile,
          current_user
        )

        render(json: resources)
      end

      protected

      def resource_params
        params.require(:profile_data)
      end

      def list_resources(params, includes = nil)
        profile = Models::V1::Profile.find(params[:profile_id])

        permission_error!('You may not view this profile') unless profile.readable_by?(current_user)

        query = profile.profile_data

        data_type_ids = Models::V1::Scope
          .find_by(name: params[:scope_name])
          .profile_data_type_ids

        return query if data_type_ids.blank?

        query.where(profile_data_type_id: data_type_ids)
      rescue ActiveRecord::RecordNotFound => e
        not_found!('Profile not found')
      end
    end
  end
end
