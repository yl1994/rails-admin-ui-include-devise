class CreateExceptionLogs <  ActiveRecord::Migration[6.0]
  def change
    create_table :exception_logs do |t|
      t.string :title, comment: '错误标题'
      t.text :body, :limit => 4294967295, comment: '错误体'
      t.string :controller, comment: '控制器名'
      t.string :action, comment: '行为器名'
      t.text :params, comment: '参数名字'
      t.string :ip, comment: 'IP'
      t.string :local_ip, comment: '本地ip'
      t.timestamps
    end
  end
end
