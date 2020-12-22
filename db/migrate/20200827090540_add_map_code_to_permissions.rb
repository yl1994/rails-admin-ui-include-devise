class AddMapCodeToPermissions < ActiveRecord::Migration[6.0]
  def change
    add_column :permissions, :map_code, :string
  end
end
