# frozen_string_literal: true

class Auth::SessionsController < Devise::SessionsController
  layout 'auth'
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    if params.present? && current_user&.status == -1
      sign_out(@current_useruser)
      flash_msg(:error, '该账户已被冻结，请联系相关人员解冻！')
      return redirect_to new_user_session_path
    else
    super
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
