class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  load_and_authorize_resource # 校验权限 来自cancancan
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html {render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false}
      format.js { render js: "toastr.error('无权限访问')" }
    end 
  end

  protected

  def respond_back(object)
    respond_with :admin, object, :location => params[:back].presence || send("admin_#{object.class.to_s.tableize}_path")
  end

  private

    def current_ability
      # I am sure there is a slicker way to capture the controller namespace
      controller_name_segments = params[:controller].split('/')
      controller_name_segments.pop
      controller_namespace = controller_name_segments.join('/').camelize
      @current_ability ||= Ability.new(current_user, controller_namespace)
    end
end
