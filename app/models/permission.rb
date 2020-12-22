class Permission < ApplicationRecord
  validates :code, :uniqueness => {:scope => [:guard,:group_code]}
  scope :published, -> { where(is_menu: true)}
  scope :usable, -> { where(usable: true)}
  has_ancestry :cache_depth => true
  ztrees
  scope :bottom, -> {where(" ancestry_depth = 2 ")}  # 最底层

  GUARD = {"admin" => '管理员后台'}
  # 初始化权限表
  def self.init
    Rails.application.eager_load! rescue nil
    Rails.application.routes.routes.map(&:defaults).reject{|default| default[:controller] =~ /rails|application|active_storage|devise|auth|action_mailbox|admin\/home|home/ || default.blank?}.group_by{|d| d[:controller]}.each do |controller,routes|
      # route =  {:controller=>"admin/menus", :action=>"index"}
      path  = Rails.root.join("app/controllers",controller+'_controller.rb')
      @permission = {}
      @group = {}
      actions = routes.map{|c| c[:action]}
      IO.foreach(path) do |line|
        if line =~ /(def|class)(\W?)(([^#]*?)|(.*?)#.*?)$/ || line =~ /(#\s?@)([a-z]*?)\s(.*?)$/
          case ($1)
          when '# @'
            @permission[$2.to_sym] = $3.strip
          when 'def'
            def_name = ($3 || $5).strip
            if @permission != {} && actions.include?(def_name)
              guard = controller.camelize.deconstantize.underscore.presence
              root = Permission.find_or_initialize_by(guard: guard,group_code: guard,code: guard) # 顶级名称空间
              root.name = GUARD[guard]
              root.is_menu = true
              root.save
              second_permission = Permission.find_or_initialize_by(guard: guard,group_code: controller,code: PinYin.permlink(@group[:group]))   # 二级
              second_permission.name = @group[:group]
              second_permission.parent_id = root.id
              second_permission.is_menu = true
              second_permission.save
              if guard && controller && def_name.presence 
                if !@permission[:skip]
                  permission = Permission.find_by(guard: guard,group_code: controller,name: @permission[:name]) || Permission.find_by(guard: guard,group_code: controller,code: def_name) || Permission.new(guard: guard,group_code: controller,name: @permission[:name]) 
                  permission.parent_id = second_permission.id
                  permission.group_name = @group[:group]
                  permission.name =  @permission[:name]
                  permission.is_menu =   true  if @permission[:menu]
                  permission.usable =  !@permission[:disable]
                  permission.code = def_name
                  permission.desc = @permission[:name] if permission.desc.blank?
                  permission.save
                else
                  permission = permission = Permission.find_by(guard: guard,group_code: controller,name: @permission[:name]) || Permission.find_by(guard: guard,group_code: controller,map_code: def_name) || Permission.new(guard: guard,group_code: controller,name: @permission[:name]) 
                  permission.parent_id = second_permission.id
                  permission.group_name = @group[:group]
                   permission.name =  @permission[:name]
                  permission.is_menu =   true  if @permission[:menu]
                  permission.usable =  !@permission[:disable] 
                  permission.map_code = def_name
                  permission.desc = @permission[:name] if permission.desc.blank?
                  permission.save
                end
              end                    
            end
            @permission = {}
          when 'class'
            @group = @permission
            @permission = {}
          else
          end
        end
      end
    end
  end

end

