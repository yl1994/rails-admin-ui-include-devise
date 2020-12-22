# -*- encoding : utf-8 -*-
# 项目管理
# @group  项目管理
class Admin::ProjectsController < Admin::BaseController
  before_action :set_project, only: [:show, :edit, :update, :destroy,:appropriation,:appropriation_do, :appropriation_list,
    :extract_experts,:extract_experts_do,:get_file_types,:new_project_info,:create_project_info,:edit_project_info,
    :update_project_info, :show_project_info, :destroy_project_info,  :certificate,:certificate_do,:accept_certificate,:accept_certificate_do,
    :edit_certificate,:edit_certificate_do,:certificate_show,:get_experts,:edit_status,:update_status,:show_experts,:show_upload_info,:extract,:show_experts_list]

  skip_load_and_authorize_resource only: [:get_file_types,:new_project_info,:create_project_info,:edit_project_info,
    :update_project_info,:show_project_info,:destroy_project_info,:get_experts,:get_category_id, :extract,:is_notice,
    :is_join,:extract_again,:get_experts_ids,:show_experts_list]

  around_action :skip_bullet,only: [:extract_experts,:extract_experts_do,:index,:get_experts,:project_certification_index,:show_experts,:extract_again], if: -> { defined?(Bullet) }
  before_action :set_project_info, only: [:edit_project_info,:update_project_info,:show_project_info, :destroy_project_info]
  before_action :get_file_genres, only: [:create, :update, :show, :upload_info,:show_upload_info]

  # 项目一览
  # @name 项目一览
  # @menu
  def index
    params[:q] ||= {}
    @query = Project.order(id: :desc).query(current_user,params[:q])
    @projects =  @query.result.distinct.includes([:project_certifications]).page(params[:page]).per(10)
  end
  

  # 新增项目
  # @name 新增项目
  # @skip
  def new
    @project = Project.new(department_id: current_user.department_id,total_money: nil,subsidy_money: nil)
    @project.capitals.build(money: nil)
  end

  # 新增项目
  # @name 新增项目
  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
    unless @project.progress > 0
      @flag = false
      return flash.now[:error] =  "请选择项目完成进度"
    end
    if @project.save
      @flag = true
    else
      @flag = false
      flash.now[:error] =  @project.error_msg
    end
  end
  
  # 修改项目
  # @name 修改项目
  # @skip
  def edit
    
  end
 
  # 修改项目
  # @name 修改项目
  def update
    if @project.update(project_params)
      @flag = true
    else
      @flag = false
      flash.now[:error] = @project.error_msg
    end
  end

  # 删除项目
  # @name 删除项目 
  def destroy
    begin
      @project.destroy  ? flash_msg(:success) : flash_msg(:error,@project.error_msg)   
    rescue Exception => e
      flash_msg(:error,'删除失败')     
    end
    redirect_to admin_projects_path
  end


  # 项目详情
  # @name 项目详情
  def show
    @transfer_url = ''
    address_name = @project.implement_site 
    lat = @project.lat.to_s
    lng =  @project.lng.to_s
    url = "https://www.amap.com/service/shortUrl?&address=http://wb.amap.com/%3Fq%3D"+lat+"%2C"+lng+"%2C"+address_name+"%26src%3Dpc_sms_poi"
    if lat.present? && lng.present?
      res = JSON.parse(RestClient.get(URI.encode(url)))
      if res["status"] == '1'
        @transfer_url = res["data"]["transfer_url"]
      end
    end
  end

  # 操作日志
  # @name 操作日志
  def project_logs
    @audits = @project.audits.includes(:user).order(id: :desc).page(params[:page]).per(10)        
  end

  # 资金拨付
  # @name 资金拨付
  # @skip
  def appropriation
    @appropriation = @project.appropriations.build
  end

  # 资金拨付
  # @name 资金拨付
  def appropriation_do
    @appropriation = @project.appropriations.build(appropriation_params)
    @appropriation.user_id = current_user.id
    if @appropriation.save
      @flag = true
      flash_msg(:success)
    else
      @flag = false
      return flash.now[:error] = "资金拨付失败 " + @appropriation.error_msg
    end
  end
  
  # 资金拨付修改
  # @name 资金拨付修改
  # @skip
  def edit_appropriation
    @appropriation = Appropriation.find_by_id(params[:appropriation_id])
  end

  # 资金拨付修改
  # @name 资金拨付修改
  def update_appropriation
    @appropriation = Appropriation.find_by_id(params[:appropriation_id])
    @appropriation.update(appropriation_params)
    @flag = true
    @appropriations = @project.appropriations.includes(:user).order(id: :desc)
  end

  # 资金拨付记录
  # @name 资金拨付记录
  def appropriation_list
    @appropriations = @project.appropriations.includes(:user).order(id: :desc)
  end
  
  def get_file_types
    root = FileType.find_by(id: params[:file_type_id])
    @file_type_childrens = root&.children
    render partial: 'admin/projects/file_type_child_form',locals: {file_type_childrens: @file_type_childrens}
  end

  def new_project_info
    @project_info = ProjectInfo.new(project_id: params[:id], file_type_id: params[:file_type_children_id])
  end

  def create_project_info
    @project_info = ProjectInfo.new(project_info_params)
    @flag = true
    flash.now[:success] = '资料添加成功'
    @project_info.save
    @project_info.files.attach(params[:project_info][:files]) if params[:project_info][:files].present?
    pft =  ProjectFileTypeCount.find_or_initialize_by(project_id: @project.id, file_type_id: @project_info.root_file_type_id)
    pft.add_child_file_type_id(@project_info.file_type_id)
    pft.save
  end

  def edit_project_info
    @files = @project_info.files.includes([:blob])
    @initial_previews =  @project_info.files.attached? ?  @files.map{|file| file.service_url}.to_json  :  [].to_json
    @initial_preview_configs = if  @project_info.files.attached?
      file_type = Proc.new do |file|
       if file.content_type =~/image\//
         'image'
       elsif file.content_type =~/pdf/
        'pdf'
       else
        'object'
       end
      end
      @files.map{|file| {type: file_type.call(file),size: file.byte_size,caption: file.filename,key: file.id,downloadUrl: file.service_url}}.to_json 
    else
      [].to_json
    end
  end

  def update_project_info
    @project_info.update(project_info_params)
    @flag = true
    flash.now[:success] = '资料更新成功'
   begin
     @project_info.files.attach(params[:project_info][:files]) if params[:project_info][:files].present?  
   rescue Exception => e
     @flag = false
     flash.now[:error] = '文件上传失败'    
   end
  end

  def show_project_info
    @files = @project_info.files.includes([:blob])
    @initial_previews =  @project_info.files.attached? ?  @files.map{|file| file.service_url}.to_json  :  [].to_json
    @initial_preview_configs = if  @project_info.files.attached?
      file_type = Proc.new do |file|
       if file.content_type =~/image\//
         'image'
       elsif file.content_type =~/pdf/
        'pdf'
       else
        'object'
       end
      end
      @files.map{|file| {type: file_type.call(file),size: file.byte_size,caption: file.filename,key: file.id,downloadUrl: file.service_url}}.to_json 
    else
      [].to_json
    end  
  end

  def destroy_project_info
    begin
      @project = @project_info.project
      @project_info.update(is_deleted: true, deleted_at: Time.now )
      @flag = true
      flash.now[:success] = '资料删除成功'
      if @project.project_infos.by_file_type(@project_info.file_type_id).blank?
        pft =  ProjectFileTypeCount.find_by(project_id: @project.id, file_type_id: @project_info.root_file_type_id)
        if pft
          pft.del_child_file_type_id(@project_info.file_type_id)
          pft.save
        end
      end
    rescue Exception => e
      @flag = false
      render json: {success: false, msg: '删除失败'}
    end
  end

  # 抽取专家
  # @name 抽取专家
  # @skip
  def extract_experts
    # 抽取类型默认请选择
    @project.major_category_id = nil if params[:type] == 'extract'
    @extract_record = ExtractRecord.new
  end
  
  def get_category_id
    @majors = Major.ransack({major_categories_id_eq: params[:major_category_id]}).result
    render json: {success: @majors.present?, majors: [['不限', 'none']] + @majors.pluck(:name,:id)}
  end

  def get_experts_ids
    query = {}
    if params[:is_department] == "1"
      is_need_free = false
    elsif params[:is_department] == "0"
      is_need_free = true
    else
      is_need_free = nil
    end

    if params[:major_ids].blank?
      query[:major_categories_id_in] =  params[:major_category_id].to_i
    else
      query[:majors_id_in] = params[:major_ids].reject{|id| id == 'none'}
    end
    query[:need_fee_eq] = is_need_free
    @experts = Expert.ransack(query).result
    render json: {success: @experts.present?, experts: @experts.pluck(:name,:id)}
  end
 
  def extract
    flag,msg = false,''
    nums = params[:nums].to_i
    major_ids = params[:major_ids].to_a.reject{|id| id == 'none'}.map(&:to_i) 
    pass_sample_expert_ids = params[:pass_sample_expert_ids].split(",").map(&:to_i)
    pass_project_expert_ids = @project.extract_experts.pluck(:expert_id).uniq
    if params[:is_department] == "1"
      is_need_free = false
    elsif params[:is_department] == "0"
      is_need_free = true
    else
      is_need_free = nil
    end
    @experts = Expert.expert_sample(nums, params[:major_category_id].to_i,major_ids,pass_sample_expert_ids,pass_project_expert_ids,is_need_free)
    experts_ids = []
    if @experts.length >= nums
      @experts.each do |expert|
        experts_ids << expert["expert_id"]
      end
      flag = true
    else
      flag = false
      msg = '可供抽取专家数量不够'
      return render json: {success: flag, experts: [],msg: msg}
    end
    render json: {success: flag, experts: experts_ids.join(','),msg: msg}
  end
  
  def extract_again
    @record = ExtractRecord.find_by(id: params[:extract_record_id].to_i) 
    @details = @record.extract_details.where.not(is_full: 1).includes(:project)
    current_turn = @record.extract_experts.last.turn.to_i + 1
    @details.each do |detail|
      expert_json = detail.pass_experts(nil,true,true,current_turn)
      if !expert_json
         @flag = false
         @extract_experts = @record.extract_experts.order(:extract_detail_id)
        major = detail.major_category_name
        names = detail.major_name.join('、')
        num = detail.experts_number - detail.extract_experts.where.not(is_join: 2).count
         return flash.now[:error] = "本项目#{major}#{names} 可抽取专家数量不足#{num}个，请添加！"
      end
    end
    @record.check_full!
    @flag = true
    flash.now[:success] = "操作成功"
    @extract_experts = @record.extract_experts.order(:extract_detail_id)
  end

  def is_join
    @expert  = ExtractExpert.find_by(id: params[:expert_id].to_i)
    if params[:type] == "sure"
      @expert.is_join = 1
    else
      if params[:reason].blank?
        @flag = false
        return flash.now[:error] = "请填写不参与原因"
      end
      @expert.reason = params[:reason]
      @expert.is_join = 2
    end
    @expert.save
    @flag = true
    flash.now[:success] = "操作成功"
    @record = @expert.extract_record
    @record.check_full!
    @extract_experts = @record.extract_experts.order(:extract_detail_id)
  end

  # 抽取专家
  # @name 抽取专家
  def extract_experts_do
    begin
      if params[:type] == "extract"
        if params[:num].to_i == 0
          @flag = false
          return flash.now[:error] = "请填写抽取数量"
        end
        if extract_record_params["extract_details_attributes"].values.any?{|h| h['experts_ids'].blank?}
          @flag = false
          return flash.now[:error] = "专家抽取失败"
        end

        @extract_record = ExtractRecord.new(extract_record_params)
        @extract_record.save_record(params,current_user,@project)
        @extract_record.check_full!
        @flag = true
        flash.now[:success] = '操作成功'
      else
        # 选择专家
        params[:extract_record][:extract_details_attributes].each{|k,h| h['experts_ids'] = h['experts_ids'].join(',') if h['experts_ids'].is_a? Array}
        @extract_record = ExtractRecord.new(extract_record_params)
        @extract_record.is_full = 1
        @extract_record.extract_type = 2
        @extract_record.save_record(params,current_user,@project)
        @flag = true
        flash.now[:success] = '操作成功'
      end
      @extract_experts = @extract_record.extract_experts.order(:extract_detail_id)
      if @extract_experts.present?
        @project.update_columns(is_extract: true)
      end
    rescue => e
      # 异常日志记录
      ExceptionNotifier.notify_exception(e,env: request.env)
      @flag = false
      return flash.now[:error] = "保存失败,请联系技术支持"
    end
  end
  
  # 项目抽取专家显示
  # @name 项目抽取专家显示 
  def show_experts
    @extract_records =  @project.extract_records.order(extract_time: :desc)
  end

  def show_experts_list
    @extract_record = @project.extract_records.find_by_id(params[:extract_record_id]) 
    @extract_experts = @extract_record.extract_experts.order(:extract_detail_id)
  end

  # 验收申请
  # @name 验收申请
  # @skip
  def certificate
    if !current_user.e_signature.attached?
      flash_msg(:error, "未找到签名图片，请前往个人中心上传签名图片")
      return redirect_to params[:back] || admin_projects_path
    end
    @certificate = @project.project_certifications.build
  end
  
  # 验收申请
  # @name 验收申请
  def certificate_do
    if current_user.valid_password?(params[:old_password])
      @certificate = @project.project_certifications.build(project_certification_params)
      @certificate.apply_user_id = current_user&.id
      @certificate.status = 1
      @certificate.apply_is_sign = true
      @certificate.apply_signed_at = Time.now
      if @certificate.save
        @project.update_columns(certification_status: @certificate.status )
      end
      @flag = true
      flash_msg(:success)
    else
      @flag = false
      return flash_msg(:error, "当前密码不正确")
    end
  end
  
  # 审核验收
  # @name 审核验收
  # @skip
  def accept_certificate
    @accept = @project.project_certifications.where(status: 1).last
  end
 
  # 审核验收
  # @name 审核验收
  def accept_certificate_do
    begin
      ActiveRecord::Base.transaction do
        @project_certification = @project.project_certifications.where(status: 1).last
        if params[:ctype] == "agree"
          if current_user.valid_password?(params[:old_password])
            @project_certification.audit_signed_at = Time.now
            @project_certification.status = 2
            @project_certification.audit_is_sign = true 
          else
            @flag = false
            return flash_msg(:error, "当前密码不正确")
          end
        else 
          @project_certification.reason = params[:dis_reason]
          @project_certification.status = -1
        end
        @project_certification.audit_user_id = current_user.id
        @project_certification.update(project_certification_params)
        @project.update_columns(certification_status: @project_certification.status)
      end
      if @project_certification.status == 2
        @project_certification.generate_pdf(@project,request) # 生成pdf
      end     
      @flag = true
      flash_msg(:success)
    rescue Exception => e
      # 异常日志记录
      ExceptionNotifier.notify_exception(e,env: request.env)
      @flag = false
      return flash.now[:error] = "验收审核失败,请联系技术支持"  
    end

  end
  
  # 修改验收申请
  # @name 修改验收申请
  # @skip
  def edit_certificate
    if !current_user.e_signature.attached?
      flash_msg(:error, "未找到签名图片，请前往个人中心上传签名图片")
      return redirect_to params[:back] || admin_projects_path
    end
    @cert = @project.project_certifications.where(status: -1).last
    #@certificate = @project.project_certifications.new(basis: @cert.basis,content: @cert.content,advice: @cert.advice)
    @certificate = @cert.dup
  end
  
  # 修改验收申请
  # @name 修改验收申请
  def edit_certificate_do
    if current_user.valid_password?(params[:old_password])
      @certificate = @project.project_certifications.new(project_certification_params)
      @certificate.apply_user_id = current_user&.id
      @certificate.status = 1
      @certificate.apply_is_sign = true
      @certificate.apply_signed_at = Time.now
      if @certificate.save
        @project.update_columns(certification_status: @certificate.status)
      end
      @flag = true
      flash_msg(:success)
    else
      @flag = false
      return flash_msg(:error, "当前密码不正确")
    end
  end
  
  # 验收申请记录
  # @name 验收申请记录
  def certificate_show
    @accept = @project.project_certifications.last
    if [-1,2,1].include? @accept.status
      @records = @project.project_certifications
    else
      @records = @project.project_certifications.where.not(id: @accept)
    end
  end
  
  # 上传验收审核资质文件
  # @name 上传验收审核资质文件
  def upload_qalification
    @flag = false
    if !current_user.e_signature.attached?
      flash.now[:error] = "未找到签名图片，请前往个人中心上传签名图片"
      return render 'admin/projects/certificate/upload_qalification.js.erb'
    end
    audit_user = current_user.department&.leader_users&.first
    if audit_user.blank?
      flash.now[:error] = "未找到承办科室 #{current_user.department&.name} 的分管领导"
      return render 'admin/projects/certificate/upload_qalification.js.erb'
    end
    if !audit_user.e_signature.attached?
      flash.now[:error] = "未找到分管领导（#{audit_user.realname}）的签名图片"
      return render 'admin/projects/certificate/upload_qalification.js.erb'
    end
    if params.dig(:project, :qalification_file).blank?
      flash.now[:error] = "请上传验收审核资质文件"
      return render 'admin/projects/certificate/upload_qalification.js.erb'
    end
    begin
      ActiveRecord::Base.transaction do
        @project_certification = ProjectCertification.find_by_id(params[:certificate_id])
        @project_certification.audit_signed_at = Time.now
        @project_certification.status = 2
        @project_certification.audit_is_sign = true 
        @project_certification.audit_user_id = audit_user.id
        @project_certification.save
        @project.update_columns(certification_status: @project_certification.status)
      end
      if @project_certification.status == 2
        @project_certification.qalification_file.attach(params[:project][:qalification_file]) 
        @project_certification.generate_pdf(@project,request) # 生成pdf
      end   
      flash_msg(:success)
    rescue Exception => e
      # 异常日志记录
      ExceptionNotifier.notify_exception(e,env: request.env)
      flash.now[:error] = "上传验收审核资质失败,请联系技术支持"
      return render 'admin/projects/certificate/upload_qalification.js.erb'
    end
    @flag = true
    return render 'admin/projects/certificate/upload_qalification.js.erb'
  end

  # 项目资料一览
  # @name 项目资料一览
  # @menu
  def project_information_index
    params[:q] ||= {}
    @query = Project.order(id: :desc).query(current_user,params[:q])
    @projects =  @query.result.distinct.page(params[:page]).per(10)  
  end

  # 完工项目一览
  # @name 完工项目一览
  # @menu
  def project_completion_index
    params[:q] ||= {}
    params[:q][:progress_eq] = 100
    @query = Project.order(id: :desc).query(current_user,params[:q])
    @projects =  @query.result.distinct.page(params[:page]).per(10)    
  end
  
  # 完工项目验收
  # @name 完工项目验收
  # @skip
  def completion_accept
    set_project
    @project_completion_accept = @project.project_completion_accepts.build
    respond_to do |format|
        format.js { render 'admin/projects/completion/accept.js.erb'}
    end  
  end

  # 完工项目验收
  # @name 完工项目验收
  def completion_accept_do
    set_project
    @project_completion_accept = @project.project_completion_accepts.build(project_completion_accept_params)
    if @project_completion_accept.save
      @project.update_columns(accept_status: @project_completion_accept.status)
      @flag = true
      flash_msg(:success)
    else
      @flag = false
      flash.now[:error] =  @project_completion_accept.error_msg
    end
    respond_to do |format|
      format.js { render 'admin/projects/completion/accept_do.js.erb'}
    end 
  end

  # 完工项目验收详情
  # @name 完工项目验收详情
  def show_completion_accept
    set_project
    @project_completion_accept = @project.project_completion_accepts.last
    if @project_completion_accept
      @files = @project_completion_accept.files.includes([:blob])
      @initial_previews =  @project_completion_accept.files.attached? ?  @files.map{|file| file.service_url}.to_json  :  [].to_json
      @initial_preview_configs = if  @project_completion_accept.files.attached?
        file_type = Proc.new do |file|
         if file.content_type =~/image\//
           'image'
         elsif file.content_type =~/pdf/
          'pdf'
         else
          'object'
         end
        end
        @files.map{|file| {type: file_type.call(file),size: file.byte_size,caption: file.filename,key: file.id,downloadUrl: file.service_url}}.to_json 
      else
        [].to_json
      end
    end
    respond_to do |format|
      format.js { render 'admin/projects/completion/show_accep.js.erb'}
    end   
  end

  # 项目验收申请
  # @name 项目验收申请
  # @menu
  def project_certification_index
    params[:q] ||= {}
    query = {}
    of = OperationFunc.find_by_code('acceptance')  
    if current_user.has_role?('admin_leadership')
      params[:q][:certification_status_not_null] = 1 
      query[:certification_status_not_null] = 1
    end
    params[:q][:progress_gteq] = 90
    query[:progress_gteq] =   90
    if params[:q][:certification_status_eq] == "0"
      query[:certification_status_null] = 1
      @query =  Project.includes([:project_certifications]).order(id: :desc).query(current_user,query)
    else
      @query = Project.includes([:project_certifications]).order(id: :desc).query(current_user,params[:q])
    end 
    @projects =  @query.result.distinct.page(params[:page]).per(10)
    @query.certification_status_eq = params[:q][:certification_status_eq]
  end


  # 项目进度
  # @name 项目进度
  # @menu
  def project_schedule_index
    params[:q] ||= {}
    @query = Project.order(id: :desc).query(current_user,params[:q])
    @projects =  @query.result.distinct.page(params[:page]).per(10)  
  end

  # 项目资金拨付
  # @name 项目资金拨付
  # @menu
  def appropriation_index
    params[:q] ||= {}
    @query = Project.order(id: :desc).query(current_user,params[:q])
    @projects =  @query.result.distinct.page(params[:page]).per(10)  
  end


  # 项目专家抽取
  # @name 项目专家抽取
  # @menu
  def extract_expert_index
    params[:q] ||= {}
    @query = Project.order(id: :desc).query(current_user,params[:q])
    @projects =  @query.result.includes(:extract_records,:project_certifications).distinct.page(params[:page]).per(10)  
  end


  # 上传资料
  # @name 上传资料
  def upload_info
     @project_schedules = @project.project_schedules.includes([files_attachments: :blob]).order(id: :desc)  
  end

  # 查看资料
  # @name 查看资料
  def show_upload_info
     @project_schedules = @project.project_schedules.includes([files_attachments: :blob]).order(id: :desc)  
  end
  
  # 修改状态
  # @name 上传资料
  # @skip
  def edit_status
    
  end

  # 修改状态
  # @name 修改状态
  def update_status
    @project.update_columns(status: project_params[:status])
    flash_msg(:success)
    respond_back @project  
  end

  def get_experts
    @project.major_category_id = params[:major_category_id] 
    render json: {success: true, data:   render_to_string(partial: "admin/projects/chose_experts_list", locals: { project: @project })     }
  end
  
  

  # 项目进度调整
  # @name 项目进度调整
  # @skip
  def project_schedule
    @project_schedule_last =  @project.project_schedules.last
    @project_schedule = @project.project_schedules.build
    @project_schedule.progress = @project_schedule_last&.progress.presence || @project.progress
    @project_schedule.schedule_at = Time.now
  end

  # 项目进度调整
  # @name 项目进度调整
  def project_schedule_do
    begin
      ActiveRecord::Base.transaction do
        @project_schedule = @project.project_schedules.build(project_schedule_params)
        @project_schedule.user_id = current_user.id
        if @project_schedule.save
          @project.update(progress:  @project_schedule.progress)
          @flag = true
          flash_msg(:success)
        else
          @flag = false
          return flash.now[:error] = "进度调整失败 " + @project_schedule.error_msg
        end
        @project_schedule.files.attach(params[:project_schedule][:files]) if params[:project_schedule][:files].present?
      end  
    rescue Exception => e
       @flag = false
       ExceptionNotifier.notify_exception(e,env: request.env)
       return flash.now[:error] = "进度调整失败,请联系技术支持" 
    end

  end

  # 项目进度记录
  # @name 项目进度记录
  def project_schedule_list
    @project_schedules = @project.project_schedules.includes(:user,[files_attachments: :blob]).order(id: :desc)
  end

  # 项目导出
  # @name 项目导出 
  # @skip 
  def excel
  end

  # 项目导出
  # @name 项目导出 
  def import
    params[:q] = JSON.parse params[:q]
    projects = Project.ransack(params[:q]).result
    excel_key = []
    excel_value = []
    params[:project] && params[:project].keys.each do |key|
        excel_key << key
        excel_value << params[:project][key]
    end  
    send_data(Project.import_expert(projects, excel_key, excel_value),
        :type => "text/excel;charset=utf-8;header=present",
        :filename => "项目列表.xls")
  end
  
  private
    def set_project
      @project = Project.find_by(id: params[:id])
    end

    def set_project_info
      @project_info = ProjectInfo.find_by(id: params[:project_info_id])
    end

    def get_file_genres
      #@file_types = @project.project_genre&.file_types&.roots&.show
      @file_types = FileType.roots&.show
    end

    def project_params
      params.require(:project).permit(:special_name, :name, :major_category_id, :department_id,:is_extract, :construct_company_name,
        :project_genre_name, :subsidy_money,:approval_at, :plan_completion_at, :completion_at, :status, :progress,
        :extract_type,:appropriation_money, :implement_site,:implement_unit,:lng, :lat,:remark,capitals_attributes: [:id,:origin,:money,:_destroy])
    end

    def appropriation_params
       params.require(:appropriation).permit(:money,:appropriation_at,:remark)  
    end

    def project_info_params
      params.require(:project_info).permit(:name,:file_type_id,:project_id)   
    end

    def project_completion_accept_params
      params.require(:project_completion_accept).permit(:status,:remark,files: [])   
    end

    def project_certification_params
      params.require(:project_certification).permit(:department_name,:apply_at,:acceptance_at,:project_id,:audit_at,:project_name ,:construct_company_name,:basis,:content,:advice,:apply_user_id,:apply_user_name,:apply_is_sign,:apply_signed_at,:audit_user_id,:audit_user_name,:audit_is_sign,:audit_signed_at,:acceptance_type,:reason)   
    end

    def project_schedule_params
      params.require(:project_schedule).permit(:progress,:schedule_at,:remark)    
    end

    def user_params
      params.require(:user).permit( :loginname,:realname,:password,:old_password,:e_signature)
    end

    def extract_record_params
      params.require(:extract_record).permit( :project_id,:project_name,:project_status,:extract_time,:user_name,:user_id,:extract_number,extract_details_attributes: [:major_category_id,:major_category_name,:is_department,:experts_number,:extract_expert_id, :_destroy, :experts_ids,major_ids: []])
    end

end
