class CreateMenus < ActiveRecord::Migration[6.0]
  def change
    create_table :menus do |t|
      t.string :name, default: '', comment: '菜单名称'
      t.string :ancestry, comment: '层级'
      t.string :url, default: '', comment: '菜单地址'
      t.float  :order_num,     limit: 24, default: 999.0, comment: '排序'

      t.timestamps
    end

    add_index :menus, [:order_num, :url]
    add_index :menus, [:order_num, :name]
  end
end
