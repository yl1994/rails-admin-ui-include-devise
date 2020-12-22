# -*- encoding : utf-8 -*-
# 角色管理
# @group  角色管理
class Admin::RolesController < Admin::BaseController
  before_action :set_role, only: [:show, :edit, :update, :destroy,:show,:assign_menus,:assign_menus_do,:assign_permissions,:assign_permissions_do]

  # 角色一览
  # @name 角色一览
  # @menu
  def index
    @query = Role.ransack(params[:q])
    @roles =  @query.result.page(params[:page]).per(10)
  end
  
  # 角色详情
  # @name 角色详情
  def show
  end

  # 新增角色
  # @name 新增角色
  # @skip
  def new
    @role = Role.new
  end

  # 新增角色
  # @name 新增角色
  def create
    @role = Role.new(role_params)
    @role.save ? flash_msg(:success) : flash_msg(:error,@role.error_msg)
    respond_back @role
  end
  
  # 修改角色
  # @name 修改角色
  # @skip
  def edit
 
  end
 
  # 修改角色
  # @name 修改角色
  def update
    @role.update(role_params) ? flash_msg(:success) : flash_msg(:error,@role.error_msg)
    respond_back @role
  end

  # 删除角色
  # @name 删除角色 
  def destroy
    begin
    @role.destroy  ? flash_msg(:success) : flash_msg(:error,@role.error_msg)   
    rescue Exception => e
       flash_msg(:error,'删除失败')     
    end
    redirect_to admin_roles_path
  end
  
  # 分配菜单
  # @name 分配菜单
  # @skip
  def assign_menus
    menu_ids = @role.role_menus.pluck(:menu_id)
    @menus = Menu.to_sorted_nodes.to_ztree_node.each do |h|
       h.merge!(:open => true,:checked => (menu_ids.include? h[:id]))     
    end
  end
  
  # 分配菜单
  # @name 分配菜单
  def assign_menus_do
    params[:checked_data].each do |flag,ids|
      next if ids.length == 0
      flag == "true" ? (@role.menus << Menu.where(id: ids)) : @role.role_menus.where(menu_id: ids).destroy_all
    end
    flash_msg(:success)
    render :status => 200, :plain => 'ok'
  end

  # 分配权限
  # @name 分配权限
  # @skip
  def assign_permissions
    permission_ids = @role.role_permissions.pluck(:permission_id)
    @permissions = Permission.usable.to_sorted_nodes.to_ztree_node.each do |h|
       h.merge!(:open => true,:checked => (permission_ids.include? h[:id]))     
    end
  end
  
  # 分配权限
  # @name 分配权限
  def assign_permissions_do
    params[:checked_data].each do |flag,ids|
      next if ids.length == 0
      flag == "true" ? (@role.permissions << Permission.where(id: ids)) : @role.role_permissions.where(permission_id: ids).destroy_all
    end
    flash_msg(:success)
    render :status => 200, :plain => 'ok'
  end

  private
    def set_role
      @role = Role.find_by(id: params[:id])
    end

    def role_params
      params.require(:role).permit( :name,:desc,:code)
    end
  

end
