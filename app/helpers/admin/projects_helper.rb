module Admin::ProjectsHelper
  def change_text(column,text)
    case column.to_sym
    when :status
      Project::STATUS[text]
    else
      tooltip(text)   
    end    
  end
end
