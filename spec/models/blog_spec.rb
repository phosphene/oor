require 'minitest/autorun'
# Let's have pretty test reports: https://github.com/CapnKernul/minitest-reporters
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new
require_relative '../../app/models/blog'
require_relative  '../spec_helper_lite'
require 'ostruct'

describe Blog do 
  before do
    @entries = []
    @it = Blog.new(lambda{@entries})
  end

  it "starts out with no entries" do
    @it.entries.must_be_empty
  end

  describe "#new_post" do
    before do
      @new_post = OpenStruct.new
      @it.post_source = ->{ @new_post }
    end

    it "returns a new post" do
      @it.new_post.must_equal @new_post
    end
    it "sets the post's blog reference to this blog" do
      @it.new_post.blog.must_equal(@it)
    end
    it "accepts an attribute hash on behalf of the post maker" do
      post_source = MiniTest::Mock.new
      post_source.expect(:call, @new_post, [{x: 42, y: 'z'}])
      @it.post_source = post_source
      @it.new_post(x: 42, y: 'z')
      post_source.verify
    end
  end

  describe "#add_entry" do
    it "adds the entry to the blog's list of entries" do
      entry = stub!
      mock(entry).save
      @it.add_entry(entry)
    end
  end
  
end
