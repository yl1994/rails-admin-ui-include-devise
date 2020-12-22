 # -*- encoding : utf-8 -*-
# 用户管理
# @group  用户管理
class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit,:update_pwd, :assign_roles,:assign_roles_do,:assign_departments,:assign_departments_do,:assign_leader,:assign_leader_do, :update, :destroy,:cancel_assign,:cancel_assign,:freeze_user]

  # 用户一览
  # @name 用户一览
  # @menu
  def index
    @query = User.no_yggc.ransack(params[:q])
    @users =  @query.result.includes([:user_roles,:roles]).page(params[:page]).per(10)
  end

  # 新增用户
  # @name 新增用户
  # @skip
  def new
    @user = User.new
  end

  # 新增用户
  # @name 新增用户
  def create
    @user = User.new(user_params)
    @user.save ? flash_msg(:success) : flash_msg(:error,@user.error_msg)
    respond_back @user
  end

  # 修改用户
  # @name 修改用户
  # @skip
  def edit
  end

  # 修改用户
  # @name 修改用户
  def update
    @user.update(user_params) ? flash_msg(:success) : flash_msg(:error,@user.error_msg)
    respond_back @user
  end

  # 删除用户
  # @name 删除用户 
  def destroy
    begin
      @user.destroy ? flash_msg(:success) : flash_msg(:error,@user.error_msg)
    rescue
      flash_msg(:error,'删除失败')
    end
    respond_back @user
  end

  # 用户详情
  # @name 用户详情
  def show
  end

  # 修改用户密码
  # @name 修改用户密码
  def update_pwd
    unless @user.valid_password?(params[:old_password])
      flash_msg(:error, "当前密码不正确")
      return redirect_to edit_admin_user_path
    end
    if password_params[:password].blank? || password_params[:password_confirmation].blank?
      flash_msg(:error, "密码不能为空!")
      return redirect_to edit_admin_user_path
    end
    if @user.update(password_params)
      flash_msg(:success, "修改密码成功！")
      sign_out(@user)
      return redirect_to admin_users_path
    else
      flash_msg(:error, "密码修改失败")
      return redirect_to edit_admin_user_path
    end
  end

  #重置密码
  # @name 重置密码
  def reset_password
    @user = User.find_by(id: params[:id])
    @user.password = 123456
    @user.save ? flash_msg(:success) : flash_msg(:error,@user.error_msg)
    flash_msg(:info, @user.loginname + " 密码已重置为 123456！")
    redirect_to admin_users_path
  end

  # 角色分配
  # @name 角色分配
  # @skip
  def assign_roles
    @roles = Role.order(id: :asc)
  end
  
  # 角色分配
  # @name 角色分配
  def assign_roles_do
    begin
      @user.update(user_params) 
      flash_msg(:success) 
    rescue => e
      # 异常日志记录
      ExceptionNotifier.notify_exception(e,env: request.env)
      flash_msg(:error,'更新失败')
    end
    redirect_to admin_users_path
  end

  # 用户单位分配
  # @name 用户单位分配
  # @skip
  def assign_departments
    @departments = Department.order(id: :asc) 
  end
  
  # 用户单位分配
  # @name 用户单位分配
  def assign_departments_do
    begin
      @user.update(user_params)
      flash_msg(:success)
    rescue => e
      # 异常日志记录
      ExceptionNotifier.notify_exception(e,env: request.env)
      flash_msg(:error,'更新失败')
    end
    redirect_to admin_users_path
  end

  # 分配科室
  # @name 分配科室 
  # @skip  
  def assign_leader
    @adep_ids = Department.all.ids
    @udep_ids = []
    UserDepartment.all.each do |e|
      @udep_ids << e.department_id
    end
    @dep_ids = @adep_ids - @udep_ids.uniq
    @departments = Department.where(id: @dep_ids).to_ary
  end

  # 分配科室
  # @name 分配科室 
  def assign_leader_do
    begin
      if @user.update(user_params)
        @flag = true
        flash_msg(:success)
      else
        @flag = false
        return flash.now[:error] = "科室保存失败 " + @user.error_msg
      end
      respond_back @user
    rescue => e
      # 异常日志记录
      ExceptionNotifier.notify_exception(e,env: request.env)
      @flag = false
      return flash.now[:error] = "科室保存失败,请联系技术支持"
    end
  end 

  # 取消科室
  # @name 取消科室 
  # @skip  
  def cancel_assign
    @dep_ids = []
    UserDepartment.where(user_id: @user.id).each do |e|
      @dep_ids << e.department_id
    end
    @departments = Department.where(id: @dep_ids).to_ary
  end

  # 取消科室
  # @name 取消科室 
  def cancel_assign_do
    begin
      if @user.update(user_params)
        @flag = true
        flash_msg(:success)
      else
        @flag = false
        return flash.now[:error] = "科室保存失败 " + @user.error_msg
      end
      respond_back @user
    rescue => e
      # 异常日志记录
      ExceptionNotifier.notify_exception(e,env: request.env)
      @flag = false
      return flash.now[:error] = "科室保存失败,请联系技术支持"
    end
  end

  # 冻结用户
  # @name 冻结用户 
  def freeze_user
    @user.update(status: params[:status])
    redirect_to params[:back].presence || :back
  end

  private
    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def set_user
      @user = User.find_by(id: params[:id])
    end

    def user_params
      params.require(:user).
      permit( :loginname,:realname,:email,:phone,:password, :password_confirmation,:encrypted_password,:status,
        :e_signature, :project_count, :department_id,role_ids: [])
    end  

end
