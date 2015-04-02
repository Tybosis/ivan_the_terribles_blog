class Post < ActiveRecord::Base
  attr_accessible :body, :title
  has_many :comments, dependent: :destroy
  after_save :expire_post_all_cache
  after_destroy :expire_post_all_cache

  def self.all_cached
    Rails.cache.fetch('Post.includes(comments: [:replies]).find((1..20).to_a)') { all }
  end

  def expire_all_post_cache
    Rails.cache.delete('Post.includes(comments: [:replies]).find((1..20).to_a)') { all }
  end
end
