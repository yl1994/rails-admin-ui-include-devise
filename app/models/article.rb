class Article < ApplicationRecord
  belongs_to :user,  optional: :true
  belongs_to :category, class_name: 'ArticleCategory', :foreign_key => :category_id

  validates_presence_of :title, :content

  scope :published, -> { where(:published => true)}

  has_one_attached :file, :dependent => :destroy

  before_save do
  	if self.published_changed? && self.published
  		self.published_at = Time.now
  	end
  end
end
