# frozen_string_literal: true

class APIKeyRepository
  def initialize(user_repo)
    @store = []
    if user_repo.is_a? UserRepository
      @user_repo = user_repo
    else
      raise ArgumentError.new "user_repo is of the wrong type, should be #{}"
    end
  end

  def read_by_id(apikey_id)
    if apikey_id.is_a? Integer
      @store.find { |apikey| apikey.id == apikey_id }
    end
  end
  def read_by_key(key)
    if key.is_a? String
      @store.find { |apikey| apikey.key == key}
    end
  end
  def get_all_by_user(userid)
    if userid.is_a? Integer
      result = @user_repo.read(userid)
      result.api_keys
    end
  end
  def is_valid?(key)
    if key.is_a? String
      @store.any? { |apikey| apikey.key == key}
    end
  end
  def create(apikey)
    if apikey.is_a? APIKey
      @store << apikey
      true
    else
      false
    end
  end

  def update(apikey)
    if apikey.is_a? APIKey
      old_apikey = @store.find { |f_old_apikey| f_old_apikey.id == apikey.id}
      @store.delete(old_apikey)
      @store << apikey
      true
    else
      false
    end
  end

  def delete(apikey)
    if apikey.is_a? APIKey
      @store.delete(apikey)
      true
    else
      false
    end
  end
end
