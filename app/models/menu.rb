class Menu < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  has_many :role_menus
  has_many :roles, through: :role_menus
  has_ancestry :cache_depth => true
  ztrees

  validate :check_ancestry_depth

  belongs_to :permission,  optional: :true

  def check_ancestry_depth
    errors.add(:ancestry_depth, "最多只支持两级") if ancestry_depth > 1
  end

  after_save do
    if self.name_changed? || self.ancestry_changed?
      self.subtree.map(&:set_way)
      self.ancestors.map(&:set_way)
    end
  end


 before_save do
  if self.permission_id_changed? && permission
    self.url =  permission.code != "index" ?  "#{permission.try(:group_code)}/#{permission.code}" : "#{permission.try(:group_code)}" 
  end
 end

  # 设置 排序字段
  default_scope { order(:order_num) }

  def set_way
    self.way_ids = self.path.map(&:id).join("-")
    self.way_names = self.path.map(&:name).join("-")
    save
  end

  def ancestry_names
    if way_names
      arr = way_names.split("-")
      arr[0...(arr.length - 1)].join("/") if arr.length > 0
    end
  end

  def self.tree(user)
    user.current_role.menus&.arrange_serializable do |parent, children|
      icon = parent.icon.presence && "fa fa-#{parent.icon}"
      {
        id: parent.id,
        text: parent.name,
        url: parent.url,
        icon: icon,
        urlType: "abosulte",
        targetType: "iframe-tab",
        children: children,
      }
    end.to_json
  end

  def self.init
    menus = [
      {
        name: "系统管理",
        icon: "folder",
      },
    ]
    menus.each do |p|
      pe = Menu.find_or_initialize_by(name: p[:name])
      pe.icon = p[:icon]
      pe.save
      permissions = Permission.published.usable.bottom
      permissions.each do |permission|
        menu = Menu.find_or_create_by(name: permission.name)
        menu.parent_id = pe.id  if menu.parent_id.blank?
        menu.permission_id = permission.id
        menu.save
      end
    end
  end
end
