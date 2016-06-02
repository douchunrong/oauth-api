require_relative 'pods_model'
require_relative 'checkin'

module Models::V1
  # A Waiver is comprised of two parts:
  #  1) the copy to which a user agrees
  #  2) a set of required data (address, for example) which is made
  #     available by a set of oauth scopes
  class Waiver
    attr_accessor :copy, :scopes

    def initialize(copy, scopes = nil)
      self.copy = copy
      self.scopes = scopes
    end
  end
end
