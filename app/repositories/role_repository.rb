# frozen_string_literal: true

class RoleRepository
  def initialize
    @store = []
  end
  def create(role)
    if role.is_a? Role
      @store << role
      true
    else
      false
    end
  end
  def read(role_id)
    @store.find {|role| role.id == role_id}
  end
  def update(role)
    if role.is_a? Role
      old_role = read(role.id)
      @store.delete(old_role)
      @store << role
      true
    else
      false
    end
  end
  def delete(role)
      if role.is_a? Role
      role_to_delete = read(role.id)
      @store.delete(role_to_delete)
      true
    else
      false
    end
  end
end
