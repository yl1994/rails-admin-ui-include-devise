class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # 软删除
  include SoftDelete
  devise :database_authenticatable, :registerable,:lockable,
         :recoverable,:trackable, :rememberable, :validatable, :timeoutable
  attr_accessor :username
  has_many :articles
  
  has_many :user_roles
  has_many :roles, through: :user_roles
  belongs_to :current_role, class_name: "Role", foreign_key: :current_role_id,  optional: :true
  accepts_nested_attributes_for :roles, allow_destroy: true

  has_many :permissions,through: :roles
  has_many :menus,through: :roles

  validates :phone, presence: true, length: { maximum: 255 },  :uniqueness=> {}
  validates :loginname, presence: true, length: { maximum: 255 },  :uniqueness=> {:case_sensitive => false }
  has_one_attached :avator
  validates :avator, file_size: { less_than_or_equal_to: 500.kilobytes },
     file_content_type: { allow: ['image/jpeg', 'image/png'] }

  # 用户状态
  STATUS = {
    -1 => '冻结',
    9 => '正常使用'
  }
  # 系统默认用户
  DEFAULT_USER = {loginname: 'admin', realname: '管理员', email: '110@qq.com',
    phone: '12345678901',password: '123456',password_confirmation: '123456',status: 9}

    
  before_validation do
    if self.encrypted_password.blank?
      self.password = self.password_confirmation = "123456"
    end

    if email.blank?
      self.email = "#{phone}@163.com"
    end
  end

  after_save do
    if roles.present? && current_role_id.blank?
      self.update_columns(current_role_id: roles.first.id)
    end
  end

  # 使用emal或者loginname登陆
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if username = conditions.delete(:username)
      where(conditions).where(["lower(loginname) = :value OR lower(phone) = :value OR lower(email) = :value", { :value => username.downcase }]).first
    else
      where(conditions).first
    end
  end
  
  # 当前角色
  def has_role?(code)
    current_role&.code  == code.to_s
  end

  # 区级主管
  def admin?
    current_role&.code == "admin_super"
  end

  # 给用户添加角色
  def add_role(role_type)
    UserRole.create(:user => self, :role_id => role_type.to_i)
  end

  # 用户的角色名显示
  def roles_name
    roles.map(&:name)
  end
end
