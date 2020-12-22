class RoleMenu< ApplicationRecord
  belongs_to :role,  optional: :true
  belongs_to :menu,  optional: :true
end
