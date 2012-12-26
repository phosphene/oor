require 'date'
require 'active_record'
require_relative '../../lib/fig_leaf'

class Post < ActiveRecord::Base
  include FigLeaf
  hide ActiveRecord::Base, ancestors: true,
       except: [Object, :init_with, :new_record?, :errors, :valid?, :save,
                :record_timestamps, :id, :id=]
  hide_singletons ActiveRecord::Calculations,
                  ActiveRecord::FinderMethods,
                  ActiveRecord::Relation

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

  def self.most_recent(limit=10)
    all(order: "pubdate DESC", limit: limit)
  end
end
