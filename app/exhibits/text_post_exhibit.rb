require_relative 'exhibit'
class TextPostExhibit < Exhibit
  def render_body
    @context.render(partial: "/posts/text_body", locals: {post: self})
  end  

  def self.applicable_to?(obj)
    obj.is_a?(Post) && !obj.picture?
  end
end
