class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # 通用方法
  include ActiveRecordTool
end
