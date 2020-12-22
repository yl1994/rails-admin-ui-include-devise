class AddIndexToUserRoles < ActiveRecord::Migration[6.0]
  def change
  	add_index :user_roles,[:user_id, :role_id],    unique: true
  end
end
