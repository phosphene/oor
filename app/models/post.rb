require 'date'
require 'active_record'

class Post < ActiveRecord::Base
  attr_accessible :title, :body, :image_url, :pubdate
  attr_accessor :blog

  validates :title, presence: true

  def publish(clock=DateTime)
    return false unless valid?
    self.pubdate = clock.now
    blog.add_entry(self)
  end
  
  def picture?
    image_url.present?
  end
end
