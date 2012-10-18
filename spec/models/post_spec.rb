require 'minitest/autorun'
# Let's have pretty test reports: https://github.com/CapnKernul/minitest-reporters
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new
require_relative '../spec_helper_lite'
stub_module 'ActiveModel::Conversion'
stub_module 'ActiveModel::Naming'
require_relative '../../app/models/post'

describe Post do
  before do
    @it = Post.new
  end

  it "starts with blank attributes" do
    @it.title.must_be_nil
    @it.body.must_be_nil
  end

  it "supports reading and writing a title" do
    @it.title = "foo"
    @it.title.must_equal "foo"
  end

  it "supports reading and writing a post body" do
    @it.body = "foo"
    @it.body.must_equal "foo"
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
  
end
