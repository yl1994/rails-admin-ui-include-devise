# -*- encoding : utf-8 -*-

# 权限管理
# @group  权限管理
# @menu

class Admin::PermissionsController < Admin::BaseController
  
  # 权限一览
  # @name 权限一览
  # @menu
  def index
    @query = Permission.bottom.order(id: :desc).ransack(params[:q])
    @permissions =  @query.result.page(params[:page]).per(params[:per].presence || 10)  
  end
  
  # 更新权限列表
  # @name 更新权限列表
  def generate_permissions
    Permission.init
    flash_msg(:success,'更新权限列表成功')
    return redirect_to params[:back] 
  end
end