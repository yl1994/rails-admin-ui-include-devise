# 后台通用模板
## 功能模块
* [x] 用户登录注册
* [x] 用户管理
* [x] 角色管理
* [x] 菜单管理
* [x] 权限管理


## 依赖版本
- Ruby 2.6.5
- Rails 6.0.3
- Bootstrap 4

## 下载并运行

```sh
git clone https://github.com/yl1994/rails-admin-ui-include-devise.git
rails-admin-ui-include-devise
```

```sh
cd rails-admin-ui-include-devise
```

```sh
bundle install
```

```sh
yarn
```

### 修改数据库配置
```sh
  cp config/settings.yml settings.local.yml # 拷贝完成后根据自己本地mysql修改 settings.local.yml里面mysql配置 
```

### 创建数据库
```sh
rails db:create
```

### 运行迁移文件
```sh
rails db:migrate
```

### 项目首次使用初始化数据
```sh
  rails db:seed
```

### 运行项目
```sh
rails s
```

### 判断是是否正式环境
```ruby
Rails.env.production? && SettingConfig.is_production
```

### 通用字段
```ruby
#  流程状态 
# 1=> 正常 0 => 暂停 -1 => 作废
status # boolean
# 假删除
is_delete #boolean defukt false
```

### 假删除使用
```ruby
  # 1. 增加 is_deleted 字段以及索引 
  # 2. 增加  deleted_at 字段
  # 2. 模型里面引入
  include SoftDelete
  # 3 可以参考user
```
