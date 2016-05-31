require_relative 'pods_model'

module V1
  class Team < PodsModel
    include DataExposureMethods

    pods_type('sprtid_team')

    initialize_common_pods_methods!
  end
end
