# frozen_string_literal: true
require 'securerandom'

class User
  attr_reader :id
  attr_accessor :role
  attr_accessor :api_keys
  attr_accessor :userid

  def initialize
    @id = SecureRandom.uuid
    @role = nil
    @api_keys = []
    @userid = -1
  end
end
