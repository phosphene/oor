require 'minitest/autorun'
# Let's have pretty test reports: https://github.com/CapnKernul/minitest-reporters
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new
require_relative '../spec_helper_lite'
require_relative '../../app/exhibits/picture_post_exhibit'
require 'ostruct'

describe PicturePostExhibit do
  before do
    @post = OpenStruct.new(
      title: "TITLE",
      body: "BODY",
      pubDate: "PUBDATE")
    @context = stub!
    @it = PicturePostExhibit.new(@post, @context)
  end

  it "delegates method calls to the post" do
    @it.title.must_equal "TITLE"    
    @it.body.must_equal "BODY"
    @it.pubDate.must_equal "PUBDATE"
  end

  it "renders itself with the appropriate partial" do
    mock(@context).render(partial: "/posts/picture_body", locals: {post: @it}) {
      "THE HTML"
    }
    @it.render_body.must_equal "THE HTML"
  end
end
