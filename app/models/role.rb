class Role < ApplicationRecord

	CODE = {'admin_super' => '超级管理员','web_normal' => '普通用户'}
  
  has_many :user_roles
  has_many :roles, through: :user_roles

  has_many :role_menus
  has_many :menus, through: :role_menus

  has_many :role_permissions
  has_many :permissions, through: :role_permissions

  validates :name, presence: true, length: { maximum: 255 }
  validates :code, presence: true, length: { maximum: 255 },  :uniqueness => { :case_sensitive => false }

  #默认id小于4的不可以删除  
  before_destroy  :can_not_destroy
  def can_not_destroy
    if self.id < 3
      errors.add(:name, :not_destroy, message: "#{name} 内置角色无法删除")
      throw(:abort)
    end
  end
 
  #角色初始化
	def self.init
		CODE.each do |k,v|
			role = Role.find_or_create_by(name: v)
			role.code = k
			role.desc = v
			role.save
			puts "============角色：#{role.name}创建成功================"
		end
	end
end
