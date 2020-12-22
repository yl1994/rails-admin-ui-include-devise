class UserRole < ApplicationRecord

  belongs_to :user,  optional: :true
  belongs_to :role,  optional: :true

  validates :user_id, :uniqueness => {:scope => :role_id}
end
