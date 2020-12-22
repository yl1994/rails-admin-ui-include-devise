class AddDeletedAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :deleted_at, :datetime
    add_column :users, :is_deleted, :boolean, default: false, comment: '是否删除'
    add_index :users,  :is_deleted
  end
end
