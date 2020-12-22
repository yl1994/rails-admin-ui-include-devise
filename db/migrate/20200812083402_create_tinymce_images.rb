class CreateTinymceImages < ActiveRecord::Migration[6.0]
  def change
    create_table :tinymce_images do |t|
    	t.string :file, comment: "文件名"
    	t.text   :description,                  comment: "描述"
    	t.string :url, comment: "路径"

    	t.timestamps
    end
  end
end
