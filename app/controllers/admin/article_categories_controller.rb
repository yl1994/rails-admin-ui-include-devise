# -*- encoding : utf-8 -*-
# 文章分类管理
# @group  文章分类管理
class Admin::ArticleCategoriesController < Admin::BaseController
  before_action :find_category, :only => [:show, :edit, :update, :destroy]

  # 文章分类一览
  # @name 文章分类一览
  # @menu
  def index
    @query = ArticleCategory.ransack(params[:q])
    @article_categories =@query.result.order("id").page(params[:page]).per(10)
  end
  
  # 新增文章分类
  # @name 新增文章分类
  # @skip
  def new
    @article_category = ArticleCategory.new
  end

  # 新增文章分类
  # @name 新增文章分类
  def create
    @article_category = ArticleCategory.new(article_category_params)
    if @article_category.save 
      @flag = true
      return flash_msg(:success)
    else
      @flag = false
      return flash.now[:error] = @article_category.error_msg
    end
  end

  def edit

  end
  
  # 修改文章分类
  # @name 修改文章分类
  def update
    if @article_category.update_attributes(article_category_params)
      @flag = true
      return flash_msg(:success)
    else
      @flag = false
      return flash.now[:error] = @article_category.error_msg
    end
  end

  # 删除文章分类
  # @name 删除文章分类
  def destroy
    @article_category.destroy ? flash_msg(:success) : flash_msg(:error)
    respond_back @article_category
  end

  # 查看文章分类
  # @name 查看文章分类
  def show
    
  end

  def article_category_params
    params.require(:article_category).permit(:name,:remark)
  end
    private

  def find_category
    @article_category = ArticleCategory.find_by(id: params[:id])
  end

end
