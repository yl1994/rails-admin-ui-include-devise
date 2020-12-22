class RolePermission < ApplicationRecord
  belongs_to :role,  optional: :true
  belongs_to :permission,  optional: :true
end
