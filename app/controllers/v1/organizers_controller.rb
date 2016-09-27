require_relative '../../models/v1/invite'
require_relative '../../models/v1/profile'
require_relative '../../models/v1/profile_datum'
require_relative 'api_controller'

module Controllers
  module V1
    class OrganizersController < ApiController
      self.model_class = Models::V1::Organizer
      self.resource_param = :organizer
    end

    class ResourceOrganizersController < ApiController
      self.model_class = Models::V1::Organizer
      self.resource_param = :organizer

      cattr_accessor :resource_class, :resource_params_key

      def index
        # check for permission!
        render(json: find_resource.organizers.as_json)
      end

      # for security purposes, #create doesn't create an organizer, rather
      # it creates an invite.
      def create
        resource = find_resource
        organizer = resource.organizers.new(resource_params)
        organizer.created_by_id = current_user_id
        organizer.organizer_id = current_user_id # to skip user validation

        # we are not saving the organizer yet, just checking that it's valid
        validation_error!(organizer.errors.messages) if organizer.invalid?

        klass = Models::V1::Invite.class_factory(organizer.class)
        invite_params = params
          .require(self.class.resource_param)
          .permit(klass.column_names)

        invite = klass.new(invite_params)
        invite.send(:"#{ self.class.resource_params_key }=", resource.id)
        invite.created_by_id = current_user_id

        invite.save!

        # no way this is right
        options = {
          include: permittable_read_includes(params[:id])
        }

        render \
          json: Service::V1::UserResourceView.factory(invite, current_user)
            .as_json(options),
          status: 201
      end

      protected

      def find_resource
        self.class.resource_class.find(params[self.class.resource_params_key])
      end
    end

    class GroupOrganizersController < ResourceOrganizersController
      self.model_class = Models::V1::GroupOrganizer
      self.resource_param = :organizer
      self.resource_class = Models::V1::Group
      self.resource_params_key = :group_id
    end

    class PlaceOrganizersController < ResourceOrganizersController
      self.model_class = Models::V1::PlaceOrganizer
      self.resource_param = :organizer
      self.resource_class = Models::V1::Place
      self.resource_params_key = :place_id
    end

    class ProfileOrganizersController < ResourceOrganizersController
      self.model_class = Models::V1::ProfileOrganizer
      self.resource_param = :organizer
      self.resource_class = Models::V1::Profile
      self.resource_params_key = :profile_id
    end
  end
end
