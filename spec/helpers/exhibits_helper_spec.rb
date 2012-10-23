require 'minitest/autorun'
# Let's have pretty test reports: https://github.com/CapnKernul/minitest-reporters
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new
require_relative '../spec_helper_lite'
require_relative '../../app/helpers/exhibits_helper'

stub_class 'PicturePostExhibit'
stub_class 'TextPostExhibit'
stub_class 'Post'

describe ExhibitsHelper do
  before do
    @it = Object.new
    @it.extend ExhibitsHelper
    @context = stub!
  end

  it "decorates picture posts with a PicturePostExhibit" do
    post = Post.new
    stub(post).picture?{true}
    assert(@it.exhibit(post, @context).class == PicturePostExhibit)
  end

  it "decorates text posts with a TextPostExhibit" do
    post = Post.new
    stub(post).picture?{false}
    assert(@it.exhibit(post, @context).class == TextPostExhibit)
  end

  it "leaves objects it doesn't know about alone" do
    model = Object.new
    @it.exhibit(model, @context).must_be_same_as(model)
  end
end
