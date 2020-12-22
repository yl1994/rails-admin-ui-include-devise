 module Admin::ModelPlateHelper

  # 输入框格式
  def format_box(model_plate_key, essential, published, index = nil, generate_notice = nil)
    case model_plate_key&.font_type
    when "none"

      if generate_notice.present? && model_plate_key&.generate_notice&.show_value.present?

        text_area_html = ""
       if essential
        if generate_notice.show_value.include?("{{}}")
# text_area_html += "<div contenteditable='true' name='announcement[generate_notices_attributes][#{index}][show_value]' id='announcement_generate_notices_attributes_#{model_plate_key.generate_notice.id}_show_value' reg=' .*?年 .*? 月 .*? 日至.*?年.*?月.*?日（提供期限自本公告发布之日起不得少于5个工作日），每天上午.*? 至.*? ，下午.*? 至 .*?（北京时间，法定节假日除外 ）' class='area_input validate[required] textarea_w' style='height: 58px; overflow-y: hidden; color: rgb(136, 136, 136);'>" + "#{model_plate_key.generate_notice.show_value.gsub("{{}}", "      ")}" + "</div>"
         text_area_html +=  text_area_tag "announcement[generate_notices_attributes][#{index}][show_value]", generate_notice.show_value.gsub("{{}}", "").gsub("_", ""), reg: model_plate_key.show_text.gsub("{{}}", ".*?"), class: "area_input validate[required] textarea_w"
        else
         text_area_html +=  text_area_tag "announcement[generate_notices_attributes][#{index}][show_value]", generate_notice.show_value.gsub("{{}}", "").gsub("_", ""), class: "area_input validate[required] textarea_w"
        end
       else
         text_area_html += text_area_tag "announcement[generate_notices_attributes][#{index}][show_value]", generate_notice.show_value.gsub("{{}}", "").gsub("_", ""), reg: model_plate_key.show_text.gsub("{{}}", ".*?"), class: "area_input textarea_w"
       end
      else  

        text_area_html = ""
        
       if essential
        if model_plate_key.show_text.include?("{{}}")
         text_area_html +=  text_area_tag "announcement[generate_notices_attributes][#{index}][show_value]", model_plate_key.show_text.gsub("{{}}", "____"), reg: model_plate_key.show_text.gsub("{{}}", ".*?"), log_reg: model_plate_key.show_text.gsub("{{}}", "      "), class: "area_input validate[required] textarea_w"
        else
         text_area_html +=  text_area_tag "announcement[generate_notices_attributes][#{index}][show_value]", model_plate_key.show_text.gsub("  ", "____"), log_reg: model_plate_key.show_text.gsub("{{}}", "      "), class: "area_input validate[required] textarea_w"
        end
       else
        if model_plate_key.show_text.include?("{{}}")
         text_area_html += text_area_tag "announcement[generate_notices_attributes][#{index}][show_value]", model_plate_key.show_text.gsub("{{}}", "____"), reg: model_plate_key.show_text.gsub("{{}}", ".*?"), class: "area_input textarea_w"
        else
         text_area_html += text_area_tag "announcement[generate_notices_attributes][#{index}][show_value]", model_plate_key.show_text.gsub("{{}}", "____"), class: "area_input textarea_w"
        end
       end
     end
       # if model_plate_key.explain.present?
       #  text_area_html  += hidden_field_tag "announcement[generate_notices_attributes][#{index}][show_value]", model_plate_key.explain
       # end
       raw text_area_html
    when "text_box"
      # 修改 如果存在
      if generate_notice.present? && generate_notice&.show_value.present?

       if essential
        if model_plate_key.is_money 
          text_field_tag "announcement[generate_notices_attributes][#{index}][show_value]", generate_notice.show_value,class: "edit_name validate[required] money"
        else
          text_field_tag "announcement[generate_notices_attributes][#{index}][show_value]", generate_notice.show_value,class: "edit_name validate[required]"
        end
       else
         text_field_tag "announcement[generate_notices_attributes][#{index}][show_value]", generate_notice.show_value,class: "edit_name"
       end
      else
       if essential
        if model_plate_key.is_money 
          text_field_tag "announcement[generate_notices_attributes][#{index}][show_value]", nil,class: "edit_name validate[required] money"
        else
          text_field_tag "announcement[generate_notices_attributes][#{index}][show_value]", nil,class: "edit_name validate[required]"
        end
       else
         text_field_tag "announcement[generate_notices_attributes][#{index}][show_value]", nil,class: "edit_name"
       end
      end 
    when "big_text_box"
      if essential
        text_area_tag "announcement[generate_notices_attributes][#{index}][show_value]", model_plate_key&.name, rows: 3, cols: 20, class: "edit_name validate[required] textarea_w"
      else
        text_area_tag "announcement[generate_notices_attributes][#{index}][show_value]", model_plate_key&.name, rows: 3, cols: 20, class: "edit_name textarea_w"
      end
    when "check_box"
      if generate_notice.present? && generate_notice&.show_value.present?
        flag = false
        flag = generate_notice&.show_value == model_plate_key.name
        if essential
          check_box_html = ""
             check_box_html += check_box_tag "announcement[generate_notices_attributes][#{index}][show_value]",model_plate_key.name, flag, disable: false, class: "edit_name validate[required]"
             #check_box_html += "#{model_plate_key.show_text}&nbsp;&nbsp;"

         end 
      else
        if essential
          check_box_html = ""
             check_box_html += check_box_tag "announcement[generate_notices_attributes][#{index}][show_value]",model_plate_key.name, false, class: "edit_name validate[required]"
             #check_box_html += "#{model_plate_key.show_text}&nbsp;&nbsp;"
         end 

      end       
     raw check_box_html
     end
  end


  
  #  表传id查询相关上级无限级联下拉框 搭配js
  def model_plate_selects(data_class, model_plate_id, value_id, aim_id, level = 0, text_id = '', prompt = '请选择', options = {})
    options = {:class => 'multi-level custom-select-fixed-width', :otype => data_class.to_s, :aim_id => aim_id, :text_id => text_id }.merge!(options)
    if data_class.respond_to?(:published)
      value_object = data_class.published.find_by(id: value_id, model_plate_id: model_plate_id)
    else
      value_object = data_class.find_by(id: value_id, model_plate_id: model_plate_id)
    end
    select_text = value_object.try(:has_children?) ? collection_select('value_object-parent-id', 0, value_object.children.where(model_plate_id: model_plate_id), :id, :name, {:selected => value_object.try(:id), :prompt => prompt}, options) : ''
    #aim_id = object.class.to_s.tableize.singularize + "_" + ref.to_s.singularize + "_id"
    aim_id = aim_id.to_s
    while value_object and value_object.parent and value_object.ancestry_depth > level
      select_text = collection_select('value_object-parent-id', value_object.id, value_object.parent.children.where(model_plate_id: model_plate_id), :id, :name, {:selected => value_object.try(:id), :prompt => prompt}, options) << select_text
      value_object = value_object.parent
    end
    if data_class.respond_to?(:published)
      select_text = collection_select('value_object-parent-id', 0, data_class.published.where("ancestry_depth = #{level}").where(model_plate_id: model_plate_id), :id, :name, {:selected => value_object.try(:id), :prompt => prompt}, options) << select_text
    else
      select_text = collection_select('value_object-parent-id', 0, data_class.where("ancestry_depth = #{level}").where(model_plate_id: model_plate_id), :id, :name, {:selected => value_object.try(:id), :prompt => prompt}, options) << select_text
    end
    raw select_text
  end

end