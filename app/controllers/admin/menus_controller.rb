# -*- encoding : utf-8 -*-

# 菜单管理
# @group  菜单管理
class Admin::MenusController < Admin::BaseController
  before_action :set_menu, only: [:show, :edit, :update, :destroy,:show]

  # 菜单一览
  # @name 菜单一览
  # @menu
  def index
    @query = Menu.order(id: :desc).ransack(params[:q])
    @menus =  @query.result.page(params[:page]).per(10)
  end

  # 菜单详情
  # @name 菜单详情
  def show

  end

  # 新增菜单
  # @name 新增菜单
  # @skip
  def new
    @menu = Menu.new
  end

  # 新增菜单
  # @name 新增菜单
  def create
    @menu = Menu.new(menu_params)
    @menu.save ? flash_msg(:success) : flash_msg(:error,@menu.error_msg)
    respond_back @menu
  end

  # 修改菜单
  # @name 修改菜单
  # @skip
  def edit
 
  end

  # 修改菜单
  # @name 修改菜单
  def update
    @menu.update(menu_params) ? flash_msg(:success) : flash_msg(:error,@menu.error_msg)
    respond_back @menu
  end

  # 删除菜单
  # @name 删除菜单 
  def destroy
    begin
    @menu.destroy  ? flash_msg(:success) : flash_msg(:error,@menu.error_msg)   
    rescue Exception => e
       flash_msg(:error,'删除失败')     
    end
    respond_back @menu
  end
  
  private
    def set_menu
      @menu = Menu.find_by(id: params[:id])
    end

    def menu_params
      params.require(:menu).permit( :name,:parent_id,:url,:order_num,:icon,:permission_id)
    end

end
