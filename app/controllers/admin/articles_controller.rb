# encoding: utf-8
# 文章管理
# @group  文章管理

class Admin::ArticlesController < Admin::BaseController
  
  before_action :find_article, :only => [:show, :edit, :update, :destroy]

  # 文章一览
  # @name 文章一览
  # @menu
  def index
    @query = Article.order("id desc").ransack(params[:q])
    @articles =  @query.result.includes([:category]).page(params[:page]).per(10)
  end

  # 新增文章
  # @name 新增文章
  # @skip
  def new
    @article = Article.includes([:category]).new(:published_at =>  Time.now.strftime("%Y-%m-%d"))
  end


  # 文章详情
  # @name 文章详情
  def show
  end

  # 新增文章
  # @name 新增文章
  def create
    @article = Article.includes([:category]).new(article_params)
    @article.user_id = current_user.id
    @article.save ? flash_msg(:success) : flash_msg(:error)
    respond_back @article
  end

  # 修改文章
  # @name 修改文章
  def update
    @article.update_attributes(article_params) ? flash_msg(:success) : flash_msg(:error)
    respond_back @article
  end

  # 删除文章
  # @name 删除文章 
  def destroy
    @article.destroy ? flash_msg(:success) : flash_msg(:error)
    respond_back @article
  end

  private

  def find_article
    @article = Article.find_by(id: params[:id])
  end

  def article_params
    params.require(:article).permit(:title,:content,:position,:published,:published_at, :category_id, :file)
  end
end
