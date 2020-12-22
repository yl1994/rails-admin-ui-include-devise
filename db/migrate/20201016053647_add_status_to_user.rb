class AddStatusToUser < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :status, :integer, default: 9, comment: '用户状态'
  end
end
