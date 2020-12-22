class Appropriation < ApplicationRecord
  include SoftDelete
  belongs_to :project,  optional: :true
  belongs_to :user,  optional: :true
  audited only:[:money,:appropriation_at], associated_with: :project   # 日志

  before_save do
    if appropriation_at_changed? && appropriation_at
      self.appropriation_index_month = appropriation_at.index_month
    end
  end

  after_save do
    # 保存之后计算资金来源
    p = project
    appropriations = p.appropriations.reload 
    p.update_columns(appropriation_money: appropriations.map(&:money).sum)
  end

  after_destroy do
    # 删除之后计算资金来源
    p = project
    appropriations = p.appropriations.reload 
    p.update_columns(appropriation_money: appropriations.map(&:money).sum)
  end

  after_restore do
    # 恢复之后计算资金来源
     p = project
    appropriations = p.appropriations
    p.update_columns(appropriation_money: appropriations.map(&:money).sum)
  end
end
