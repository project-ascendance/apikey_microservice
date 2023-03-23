# frozen_string_literal: true
require 'securerandom'

class APIKey
  attr_reader :id
  attr_accessor :key
  attr_accessor :user

  def initialize
    @id = SecureRandom.uuid
    @key = SecureRandom.urlsafe_base64(200)
    @user = nil
  end
end
