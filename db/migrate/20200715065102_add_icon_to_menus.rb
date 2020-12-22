class AddIconToMenus < ActiveRecord::Migration[6.0]
  def change
    add_column :menus, :icon, :string, comment: '图标'
  end
end
