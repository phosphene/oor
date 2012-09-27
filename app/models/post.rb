class Post
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  attr_accessor :title, :body, :blog

  def initialize(attrs={})
    attrs.each do |k,v| send("#{k}=", v) end
  end

  def publish
    blog.add_entry(self)
  end

  # Need this to allow form_for to decide if this is an edit or new
  def persisted?
    false
  end
end
