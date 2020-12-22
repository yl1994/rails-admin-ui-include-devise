Date::DATE_FORMATS[:default] = "%Y-%m-%d"
Time::DATE_FORMATS[:default] = "%Y-%m-%d %H:%M:%S"
Time::DATE_FORMATS[:minutes] = "%Y-%m-%d %H:%M"
Time::DATE_FORMATS[:hours] = "%Y-%m-%d %H"
Time::DATE_FORMATS[:only_date] = "%Y-%m-%d"

class Time
  # 一年的第几周
  def yweek
    strftime("%U").to_i + 1
  end

  def index_day
     self.strftime('%Y%m%d').to_i  
  end
  def index_month
     self.strftime('%Y%m').to_i  
  end
end

class Date
  # 一年的第几周
  def yweek
    strftime("%U").to_i + 1
  end

  def index_day
     self.strftime('%Y%m%d').to_i  
  end
  def index_month
     self.strftime('%Y%m').to_i  
  end
end