class AddOrderNumToPermissions < ActiveRecord::Migration[6.0]
  def change
    add_column :permissions, :order_num, :float, comment: '序号'
    add_index :permissions, :order_num
  end
end
