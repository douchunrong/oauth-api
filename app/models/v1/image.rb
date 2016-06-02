require 'php_serialize'

require_relative 'pods_model'

module Models::V1
  class Image < PodsModel
    include DataExposureMethods

    pods_type('attachment')

    initialize_common_pods_methods!

    field :url, :guid
  end
end
