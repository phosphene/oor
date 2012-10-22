require 'minitest/autorun'
# Let's have pretty test reports: https://github.com/CapnKernul/minitest-reporters
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new
require_relative '../spec_helper_lite'
require_relative '../../app/models/post'

describe Post do
  before do
    @it = Post.new(title: "Post title")
  end

  it "starts with blank attributes" do
    @post_created_without_args = Post.new
    @post_created_without_args.title.must_be_nil
    @post_created_without_args.body.must_be_nil
    @post_created_without_args.image_url.must_be_nil
  end

  it "supports reading and writing a title" do
    @it.title = "foo"
    @it.title.must_equal "foo"
  end

  it "supports reading and writing a post body" do
    @it.body = "foo"
    @it.body.must_equal "foo"
  end

  it "supports reading and writing an image_url" do
    @it.image_url = "http://example.com"
    @it.image_url.must_equal "http://example.com"
  end

  it "supports reading and writing a blog reference" do
    blog = Object.new
    @it.blog = blog
    @it.blog.must_equal blog
  end

  it "should be able to accept attributes when being created" do
    new_post = Post.new(title: "Initial Title", body: "The info")
    new_post.title.must_equal "Initial Title"
    new_post.body.must_equal "The info"
  end

  it "is not valid with a blank title" do 
    [nil, '', ' '].each do |bad_title|
      @it.title = bad_title
      refute @it.valid?
    end
  end

  it "is valid with a non-blank title" do
    @it.title = "my title"
    assert @it.valid?
  end

  describe "#publish" do
    before do
      @blog = MiniTest::Mock.new
      @it.blog = @blog
    end
    
    after do
      @blog.verify
    end

    it "adds the post to the blog" do
      @blog.expect :add_entry, nil, [@it]
      @it.publish
    end

    describe "given an invalid post" do
      before do @it.title = nil end
      
      it "won't add the post to the blog" do
        dont_allow(@blog).add_entry
        @it.publish
      end

      it "returns false" do
        refute(@it.publish)
      end
    end
  end
  
  describe "#pubdate" do 
    describe "before publishing" do
      it "is blank" do
        @it.pubdate.must_be_nil
      end 
    end  
    describe "after publishing" do      
      before do
        @clock = stub! 
        @now = DateTime.parse("2011-09-11T02:56") 
        stub(@clock).now(){@now}
        @it.blog = stub!
        @it.publish(@clock) 
      end
      
      it "is the current time" do
        @it.pubdate.must_equal(@now)
      end
      
      it "is a datetime" do
        @it.pubdate.class.must_equal(DateTime)
      end 
    end
  end

  describe "#picture?" do 
    it "is true when the post has an picture url" do
      @it.image_url = "http://example.com/ex.jpg"
      assert(@it.picture?)
    end  

    it "is fase when the post has a blank picture url" do
      @it.image_url = ''
      refute(@it.picture?)
    end  
  end  
end
