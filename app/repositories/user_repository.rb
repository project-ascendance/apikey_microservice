# frozen_string_literal: true

class UserRepository
  def initialize
    @store = []
  end

  def create(user)
    if user.is_a? User
      @store << user
      true
    else
      false
    end
  end

  def read(user_id)
    @store.find { |user| user.id == user_id }
  end

  def update(user)
    if user.is_a? User
      old_user = read(user.id)
      @store.delete(old_user)
      @store << user
      true
    else
      false
    end
  end

  def delete(user)
    if user.is_a? User
      user_to_delete = read(user.id)
      user.delete(user_to_delete)
      true
    else
      false
    end
  end
end
