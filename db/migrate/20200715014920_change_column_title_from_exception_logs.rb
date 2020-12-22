class ChangeColumnTitleFromExceptionLogs < ActiveRecord::Migration[6.0]
  def change
    change_column :exception_logs, :title, :text, comment: '错误标题'
  end
end
