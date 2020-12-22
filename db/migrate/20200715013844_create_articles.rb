class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string   "title",       comment: '文章标题'
      t.longtext     "content",     comment: '文章内容'
      t.boolean  "published",   default: false,     comment: '是否发布'
      t.float    "position",   limit: 24, default: 0.0,     comment: '文章排序'
      t.integer  "user_id",     comment: '文章作者'
      t.datetime "published_at",     comment: '文章发布时间'
      t.timestamps   
    end
  end
end
