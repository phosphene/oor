class BlogController < ApplicationController
  def index
    @blog = Blog.new
    post1 = @blog.new_post
    post1.title = "First entry"
    post1.body = "I am so excited about my new blog"
    post1.publish
    post2 = @blog.new_post(title: "Still writing")
    post2.body = "Second day of my blog; new exciting post."
    post2.publish    
  end
end
