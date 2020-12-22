class Admin::HomeController < Admin::BaseController
  skip_load_and_authorize_resource
  def index
    render layout: "backpanel"
  end

  def welcome
    @user_count = User.count
  end

  def update_my_info
    current_user.update(user_params) ? flash_msg(:success) : flash_msg(:error,@current_user.error_msg)
    redirect_to admin_root_path 
  end
  
  def update_signature
    if params.dig(:user,:e_signature).blank?
       @flag = false
       return flash_msg(:error, "请选择签名图片上传！")
    elsif current_user.update(user_params)
      flash_msg(:success, "个人签名上传成功！")
      @flag = true
      return flash_msg(:success)
    else
      flash_msg(:error, "个人签名上传失败！")
      @flag = false
      return flash_msg(:error)
    end
  end

  def update_my_password
    unless current_user.valid_password?(user_params[:old_password])
       @flag = false
       return flash_msg(:error, "当前密码不正确")
    end
    if password_params[:password].blank? || password_params[:password_confirmation].blank?
      return flash_msg(:error, "密码不能为空!")
    end
    if current_user.update(password_params)
      flash_msg(:success, "修改密码成功！")
      @flag = true
      return flash_msg(:success)
    else
      @flag = false
      return flash.now[:error] = "密码修改失败 "
    end
  end

  def check_role
    if current_user.roles.map(&:id).exclude? params[:current_role_id].to_i
      return render json: {success: false, msg: '未拥有此角色无法切换'}
    end
    current_user.update_columns(current_role_id: params[:current_role_id].to_i)
    render json: {success: true, msg: '角色切换成功'}
  end

  def update_my_avator
    current_user.avator.attach(params[:avator])
    render json: {success: true, avator_url: current_user.avator.service_url}
  end

  private
    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def user_params
      params.require(:user).permit( :loginname,:realname,:email,:phone,:password, :password_confirmation,:encrypted_password,
        :old_password,:project_count,:e_signature)
    end
end
