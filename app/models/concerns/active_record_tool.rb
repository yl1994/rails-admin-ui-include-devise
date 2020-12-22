module ActiveRecordTool

  def error_msg
    errors.full_messages.join(',')
  end
end