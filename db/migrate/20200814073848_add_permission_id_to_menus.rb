class AddPermissionIdToMenus < ActiveRecord::Migration[6.0]
  def change
    add_column :menus, :permission_id, :integer, comment: '权限id'
    add_index :menus, :permission_id
  end
end
