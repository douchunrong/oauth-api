require_relative 'pods_model'
require_relative 'sport'

module V1
  class Sport < PodsModel
    include DataExposureMethods

    pods_type('sprtid_sport')

    initialize_common_pods_methods!
  end
end
