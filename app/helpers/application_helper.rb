module ApplicationHelper
  
  def notice_status(status)
    case status.to_sym
    when :error
      'danger'
    when :info
      'info'
    when :success 
      'success'
    else
      'info'     
    end
  end

  def notice_tip(status)
    case status.to_sym
    when :error
      '操作失败' 
    when :success
      '操作成功'
    when :warning
      '警告'  
    when :info
      '温馨提示'
    end

  end

  # 显示序号
  def show_index(index, per = 10)
    params[:page] ||= 1
    (params[:page].to_i - 1) * per + index + 1
  end

  def link_to_blank(*args, &block)
    if block_given?
      options      = args.first || {}
      html_options = args.second || {}
      link_to_blank(capture(&block), options, html_options)
    else
      name         = args[0]
      options      = args[1] || {}
      html_options = args[2] || {}

      # override
      html_options.reverse_merge! target: '_blank'

      link_to(name, options, html_options)
    end
  end

  # nested_form

  def link_to_add_fields(name = nil, f = nil, association = nil, options = nil, html_options = nil, &block)
    # If a block is provided there is no name attribute and the arguments are
    # shifted with one position to the left. This re-assigns those values.
    f, association, options, html_options = name, f, association, options if block_given?

    options = {} if options.nil?
    html_options = {} if html_options.nil?

    if options.include? :locals
      locals = options[:locals]
    else
      locals = { }
    end

    if options.include? :partial
      partial = options[:partial]
    else
      partial = association.to_s.singularize + '_fields'
    end

    # Render the form fields from a file with the association name provided
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: 'new_record') do |builder|
      render(partial, locals.merge!( f: builder))
    end

    # The rendered fields are sent with the link within the data-form-prepend attr
    html_options['data-form-prepend'] = raw CGI::escapeHTML( fields )
    html_options['href'] = '#'

    content_tag(:a, name, html_options, &block)
  end

  def link_to_remove_fields(name = nil, html_options = nil, &block)
    html_options['data-form-remove'] = 'delete'
    content_tag(:a, name, html_options, &block)
  end

  def fa_icon_tag(icon)
    return nil if icon.blank?
    raw %Q|<i class='fas fa-fw fa-#{icon}'></i>|
  end

  # 中文翻译
  def t_label(model,column)
    I18n.t("activerecord.attributes.#{model}.#{column}")
  end

  # 标签
  def badge_tag(text,color: 'badge-primary')
    raw "<span class='badge #{color} ml-1 pd5'>#{text}</span>"
  end

  def badges_tag(arr,color: 'badge-primary')
    raw arr.map { |element| "<span class='badge #{color} ml-1 pd5'>#{element}</span>" }.join
  end

  def link_to_btn(opts = {}, html_opts = {})
    title = opts[:title] || 'title'
    size = opts[:size] || 'btn-big'
    btn_style = opts[:btn_style] || ''
    style = {class: "btn btn-#{btn_style} ml5 " + size}.merge(html_opts)
    return link_to title, opts[:url], style if opts[:url]
    # link_to_function(title, 'history.go(-1)', style)
  end

  def link_to_back(opts = {}, html_opts = {})
    opts[:title] ||= '返回'
    opts[:size] ||= 'btn-secondary'
    link_to_btn title: opts[:title], size: opts[:size] , url: opts[:url]
  end

  def tooltip(content,title: content, placement:'right',color: 'secondary',length: 10 )
    return nil if content.blank?
    placement = %w(top left right botton).include?(placement) ? placement : 'right'
    %Q|
    <span class="#{color}" data-toggle="tooltip" data-placement="#{placement}" title="#{title}">
      #{ title == content ? truncate(content,length: length + 3) : content}
    </span>
    |.html_safe
  end


  def link_to_void(*args, &block)
    link_to(*args.insert((block_given? ? 0 : 1), "javascript:void(0);"), &block)
  end

  # 必须项，红星
  def require_span
    "<span class='text-danger'>* </span>".html_safe
  end
  
  # 当前路径
  def current_path
    request.path.split(".")[0][0] == "/" ? request.path.split(".")[0][1..-1] : request.path.split(".")[0]
  end


  #  无限级联下拉框 搭配js
  def dynamic_selects(data_class, value_id, aim_id, level = 0, text_id = '', prompt = '请选择', options = {})
    options = {:class => 'multi-level custom-select-fixed-width', :otype => data_class.to_s, :aim_id => aim_id, :text_id => text_id }.merge!(options)
    if data_class.respond_to?(:published)
      value_object = data_class.published.find_by(id: value_id)
    else
      value_object = data_class.find_by(id: value_id)
    end
    select_text = value_object.try(:has_children?) ? collection_select('value_object-parent-id', 0, value_object.children, :id, :name, {:selected => value_object.try(:id), :include_blank => prompt}, options) : ''
    #aim_id = object.class.to_s.tableize.singularize + "_" + ref.to_s.singularize + "_id"
    aim_id = aim_id.to_s
    while value_object and value_object.parent and value_object.ancestry_depth > level
      select_text = collection_select('value_object-parent-id', value_object.id, value_object.parent.children, :id, :name, {:selected => value_object.try(:id), :include_blank => prompt}, options) << select_text
      value_object = value_object.parent
    end
    if data_class.respond_to?(:published)
      select_text = collection_select('value_object-parent-id', 0, data_class.published.where("ancestry_depth = #{level}"), :id, :name, {:selected => value_object.try(:id), :include_blank => prompt}, options) << select_text
    else
      select_text = collection_select('value_object-parent-id', 0, data_class.where("ancestry_depth = #{level}"), :id, :name, {:selected => value_object.try(:id), :include_blank => prompt}, options) << select_text
    end
    raw select_text
  end
  
  def operate_buttons(object, options = {}, &block)
    return "" if object.blank? ||  (!object.is_a?(Array))
    lis1 = ""
    lis2 = ""
    muilte = ''
    muilte = 'many' if object.size > 8
    lis1_arr = object.in_groups_of(8)[0]
    lis2_arr = object.in_groups_of(8)[1]
    lis1 = lis1_arr.compact.map{|link| "#{link.gsub("href","class='dropdown-item' href")}" }.join('<div class="dropdown-divider"></div>') if lis1_arr
    lis2 = lis2_arr.compact.map{|link| "#{link.gsub("href","class='dropdown-item' href")}" }.join('<div class="dropdown-divider"></div>') if lis2_arr
    html = %Q|
      <div class="dropdown dropleft d-inline-block">
          <button class="btn btn-primary btn-sm dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            操作
          </button>
       <div class="dropdown-menu #{muilte}" aria-labelledby="dropdownMenuButton">
          <div class="dropdown-menu-item">
             #{lis1}
          </div>
          <div class="dropdown-menu-item">
             #{lis2}
          </div>
      </div>
    </div>
    |.html_safe
  end
end
