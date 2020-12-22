Rails.application.routes.draw do
  devise_for :users, controllers: {
                       sessions: "auth/sessions",
                       registrations: "auth/registrations",

                     }
  # 通用下拉级联
  get "dynamic_selects" => "application#selects"

  # 通用ajax是否重复校验
  get "check_uniq" => "application#check_uniq"

  # 富文本图片上传
  post "images_upload" => "application#images_upload"
  post "delete_attachment" => "application#delete_attachment"
  namespace :web do

  end
  namespace :admin do
    root "home#index"
    get "home/welcome", :to => "home#welcome"
    post "home/update_my_info", :to => "home#update_my_info" # 更新个人信息
    post "home/update_my_password", :to => "home#update_my_password" # 修改个人密码
    post "home/update_my_avator", :to => "home#update_my_avator" # 更新修改头像
    post "home/check_role", :to => "home#check_role" # 更新角色
    # 菜单管理
    resources :menus
    # 权限管理
    resources :permissions, only: :index do
      collection do
        post :generate_permissions
      end
    end

    #文章
    resources :articles
    #文章层级
    resources :article_categories
    # 角色管理
    resources :roles do
      member do
        get :assign_menus # 分配菜单
        post :assign_menus_do
        get :assign_permissions # 分配权限
        post :assign_permissions_do 
      end
    end
    # 异常日志
    resources :exception_logs
    # 用户管理
    resources :users do
      member do
        put :reset_password
        get :assign_roles # 分配角色
        post :assign_roles_do
        get :assign_departments # 分配单位角色
        post :assign_departments_do
        patch :update_pwd
        get :assign_leader
        post :assign_leader_do
        get :cancel_assign
        post :cancel_assign_do
        get :freeze_user
      end
    end    
  end
  root "admin/home#index"
end
