class AddIsMenuToPermissions < ActiveRecord::Migration[6.0]
  def change
    add_column :permissions, :is_menu, :boolean, default: false, comment: '是否菜单'
    add_index :permissions, :is_menu
  end
end
