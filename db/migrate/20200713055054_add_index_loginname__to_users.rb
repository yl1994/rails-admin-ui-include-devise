class AddIndexLoginnameToUsers < ActiveRecord::Migration[6.0]
  def change
  	add_index :users, :loginname,                unique: true
  end
end
