class AddCurrentRoleIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :current_role_id, :integer, comment: '当前角色ID'
  end
end
