class Post < ActiveRecord::Base
  attr_accessible :body, :title
  has_many :comments, dependent: :destroy
  after_save :expire_post_all_cache
  after_destroy :expire_post_all_cache

  def self.all_cached
    Rails.cache.fetch('Post.all') { all }
  end

  def expire_post_all_cache
    Rails.cache.delete('Post.all') { all }
  end
end
