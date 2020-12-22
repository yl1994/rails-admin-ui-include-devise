class CreateArticleCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :article_categories do |t|
      t.string :name, :comment => '名称'
      t.string :remark, :comment => '备注'
      t.timestamps
    end
    add_column :articles, :category_id, :integer
    add_index :articles, :category_id
  end
end