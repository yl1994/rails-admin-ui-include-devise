class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name,           null: false, comment: '名称'
      t.string :desc,           default: "", comment: '描述'
      t.string :code,           default: "", comment: '类型'      
      t.timestamps
    end
    add_index :roles, :code,    unique: true
  end
end