class CreateRoleMenus < ActiveRecord::Migration[6.0]
  def change
    create_table :role_menus do |t|
      t.integer :role_id
      t.integer :menu_id

      t.timestamps
    end
    add_index :role_menus, :role_id
    add_index :role_menus, :menu_id
  end
end
