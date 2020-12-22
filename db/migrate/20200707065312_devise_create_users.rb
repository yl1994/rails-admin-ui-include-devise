# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :loginname, null: false,              default: "", comment: '登录名'
      t.string :realname,               default: "", comment: '真实姓名'
      t.string :email,                  default: "", comment: '邮箱'
      t.string :phone,                  default: "", comment: '手机'
      t.string :encrypted_password, null: false, default: "",     comment: '密码'

      ## Recoverable
      t.string   :reset_password_token,     comment: '重置密码密钥'
      t.datetime :reset_password_sent_at,   comment: '重置密码发送时间'

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false,   comment: '登录次数'
      t.datetime :current_sign_in_at,   comment: '当前登录失败'
      t.datetime :last_sign_in_at,   comment: '最后登录时间'
      t.string   :current_sign_in_ip,   comment: '当前登录ip'
      t.string   :last_sign_in_ip,   comment: '最后登录ip'

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
