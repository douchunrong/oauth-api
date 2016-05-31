require_relative 'pods_model'
require_relative 'checkin'

module V1
  # @todo: Find a proper address model
  Address = Struct.new(:street, :unit, :city, :state, :zip)
  Insurance = Struct.new(:company, :type, :phone, :group_number, :member_number)

  class Profile < PodsModel
    include DataExposureMethods

    pods_type('sprtid_profile')

    initialize_common_pods_methods!

    field :first_name
    field :middle_initial
    field :last_name
    field :birth_date
    field :sprtid_code
    field :email
    field :phone
    field :gender

    field :insurance # hacking this into fields, even though method is below

    # @todo: idk... do something with this
    field :school
    field :graduation_year

    field :medical_history

    field :current_medication
    field :current_injury_or_illness

    field :height
    field :weight
    field :profile_type
    field :allergies # Array

    # many_to_many :guardians, {
    #   key: :guardian_ID,
    #   primary_key: :profile_ID
    # }

    many_to_many :checkins, {
      key: :profile,
      class: 'V1::Checkin'
    }

    one_to_one :profile_photo, {
      key: :ID,
      primary_key: :profile_photo_attachment_id
    }

    # @todo: many_to_one
    one_to_one :birth_date_proof, {
      key: :ID,
      primary_key: :birth_date_proof_attachment_id
    }
    alias _birth_date_proof birth_date_proof

    def birth_date_proof
      [_birth_date_proof]
    end

    one_to_one :cover_image, {
      key: :ID,
      primary_key: :cover_image_attachment_id
    }

    def allergies
      postmetas
        .select { |m| m[:mete_key] == __method__.to_s }
        .map { |m| m[:meta_value] }
    end

    def addresses
      [Address.new(
        meta_value(:street_address),
        meta_value(:unit),
        meta_value(:city),
        meta_value(:state),
        meta_value(:zip)
      )]
    end

    def insurance
      Insurance.new(
        meta_value(:insurance_company_name),
        meta_value(:insurance_plan_type),
        meta_value(:insurance_phone_number),
        meta_value(:insurance_member_number),
        meta_value(:insurance_group_number)
      )
    end
  end
end
