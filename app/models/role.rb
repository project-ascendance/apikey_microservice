# frozen_string_literal: true
require 'securerandom'
class Role
  attr_reader :id
  attr_accessor :description

  def initialize
    @id = SecureRandom.uuid
    @description = ''
  end
end
