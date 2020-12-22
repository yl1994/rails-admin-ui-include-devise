# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# 项目首次使用初始话数据
time = Time.now
puts "============初始化数据开始================"

# 权限
Permission.init
# 菜单
Menu.init
# 角色
Role.init
role = Role.find(1)
# 超级管理员分配菜单
# Menu.find_each do |p|
#   next if role.menus.pluck(:id).include? p.id
#   role.menus << p
# end
# puts "============角色：#{role.name} 分配菜单#{Role.find(1).menus.pluck(:name)} 成功================"
# 系统管理员角色分配权限
# role.permissions = Permission.all  # 手动执行此脚本
# 系统默认用户
user_hash =User::DEFAULT_USER
user = User.find_or_initialize_by(loginname: user_hash[:loginname])
if user.id.blank?
  user.assign_attributes(user_hash)
  user.save
end
puts "============用户：#{user.loginname}创建成功================"
user.add_role(role.id) # 分配超级管理员角色
puts "============用户：#{user.loginname}分配 #{role.name} 角色成功================"
puts "================初始化数据结束 耗时#{ Time.now - time }s==================="

