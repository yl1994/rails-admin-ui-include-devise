# -*- encoding : utf-8 -*-
# 异常日志
# @group  异常日志
class Admin::ExceptionLogsController < Admin::BaseController

  # 异常日志一览
  # @name 异常日志一览
  # @menu
  def index
    @query = ExceptionLog.order("id desc").ransack(params[:q])
    @exception_logs =  @query.result.page(params[:page]).per(10)
  end

  # 异常日志详情
  # @name 异常日志详情
  def show
    @exception_log = ExceptionLog.find_by(id: params[:id])
  end

end
