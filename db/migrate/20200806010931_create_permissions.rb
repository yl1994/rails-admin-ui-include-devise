class CreatePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions do |t|
      t.string :name, comment: '权限名称'
      t.string :code, comment: '权限编码'
      t.string :group_code, comment: '权限组编码'
      t.string :group_name, comment: '权限组名称'
      t.string :guard,  comment: '看守器(命名空间)'
      t.text   :desc, comment: '描述'

      t.timestamps
    end
    add_index :permissions, [:guard, :group_code,:code], unique: true
  end
end
