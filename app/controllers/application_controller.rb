class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :html, :js, :json, :jpg


  def flash_msg(status = :info, msg = "")
    raise 'status 无效的参数' unless [:success, :info, :success, :error].include? status.to_sym
    flash[status] = msg
  end

  def render_404
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
  
  # 通用级联下拉
  def selects
    clazz = params[:otype].to_s.singularize.camelize.constantize
    if params[:id].blank?
      @objects = clazz.all
    else
      @objects = clazz.respond_to?(:published) ? clazz.children_of(params[:id]).published : clazz.children_of(params[:id])
    end
    @objects.delete_if{|obj| params[:reject_ids].to_s.split(",").include?(obj.id.to_s) } if params[:reject_ids].present? && @objects.present?
    if params[:otype].blank? or @objects.empty? or params[:id].blank?
      render plain: ''
    else
      render :partial => "/shared/selects", :layout => false
    end
  end

  
  # 通用ajax重复校验
  def check_uniq
    clazz = params[:model_name].singularize.camelize.constantize
    column = params[:column_name]
    if params[:model_id].present?
      # 修改的情况
      flag = !clazz.where.not(id: params[:model_id]).exists?(column => params[:fieldValue])
    else
      flag =  !clazz.exists?(column => params[:fieldValue])
    end
    render json: [params[:fieldId],flag]
  end

  # 富文本图片上传
  # @name 图片上传
  def images_upload
    # { location : "/demo/image/1.jpg" }
    # images_dir = "#{Rails.root}/public/images_upload"
    # Dir.mkdir(images_dir) unless File.exist?(images_dir)
    # binding.pry
    # dir_path = [images_dir, params[:file].original_filename].join("/")
    # Dir.mkdir(dir_path) unless File.exist?(dir_path)

    # # 保存图片的绝对路径
    # save_image_path = [dir_path, image_name].clean.join("/")
    # # url路径
    # save_image_url = ["/images_upload", id, image_name].clean.join("/")
    ti = TinymceImage.create(file: params[:file].original_filename)
    ti.dyniamc_dir(params[:file])
    render json: {status: 200, file: ti.url}
  end

  
  # 删除文件
 def delete_attachment
  begin
    attachment = ActiveStorage::Attachment.find(params[:key])
    if attachment
      attachment.purge
    end
    render json: {success: true, msg: '删除成功',id: attachment&.id },status: 200
  rescue Exception => e
    render json: {success: false, msg: '删除失败'},status: 500
  end
  
 end


  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email,:phone,:loginname])
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:email,:phone,:loginname)
    end
  end
  def skip_bullet
    previous_value = Bullet.enable?
    Bullet.enable = false
    yield
  ensure
    Bullet.enable = previous_value
  end  
end
