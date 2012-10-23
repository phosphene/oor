require_relative 'exhibit'
class PicturePostExhibit < Exhibit
  def render_body
    @context.render(partial: "/posts/picture_body", locals: {post: self})
  end  

  def self.applicable_to?(obj)
    obj.is_a?(Post) && obj.picture?
  end
end
