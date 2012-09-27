class Blog
  attr_reader :entries
  attr_writer :post_source

  def initialize
    @entries = []
  end
  def title
    "My exciting blog"
  end
  def subtitle
    "Read it now!"
  end
  def new_post(*args)
    # post_source.call(*args).tap do |p|
    #   p.blog = self
    # end
    p = post_source.call(*args)
    p.blog = self
    p
  end
  def add_entry(entry)
    @entries << entry
  end
  
  private 
  def post_source
    @post_source ||= Post.public_method(:new)
  end
end
