class AddAncestryDepthToPermissions < ActiveRecord::Migration[6.0]
  def change
    add_column :permissions, :ancestry, :string,  comemnt: '层级'
    add_column :permissions, :ancestry_depth, :integer,  comemnt: '级数'
    add_index :permissions, :ancestry
    add_index :permissions, :ancestry_depth
  end
end
