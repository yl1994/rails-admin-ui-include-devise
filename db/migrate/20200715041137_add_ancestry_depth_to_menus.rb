class AddAncestryDepthToMenus < ActiveRecord::Migration[6.0]
  def change
    add_column :menus, :ancestry_depth, :integer, default:0, comment: '层级'
    add_column :menus, :way_ids, :string
    add_column :menus, :way_names, :string
  end
end
