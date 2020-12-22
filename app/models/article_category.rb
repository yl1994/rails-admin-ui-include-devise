class ArticleCategory < ApplicationRecord
  has_many :articles, :dependent => :restrict_with_error, :foreign_key => :category_id
  validates_presence_of :name
end
