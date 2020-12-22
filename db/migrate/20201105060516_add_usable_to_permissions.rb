class AddUsableToPermissions < ActiveRecord::Migration[6.0]
  def change
    add_column :permissions, :usable, :boolean, default: true, comment: '是否启用'
  end
end
