require 'minitest/autorun'
# Let's have pretty test reports: https://github.com/CapnKernul/minitest-reporters
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new
require_relative '../spec_helper_full'

describe Blog do 
  include SpecHelpers
  before do
    setup_database
    # Blog initialized with connection to the real, AR Post model for entries
    @it = Blog.new
  end

  after do
    teardown_database
  end

  describe "#entries" do
    def make_entry_with_date(date)
      @it.new_post(pubdate: DateTime.parse(date), title: date)
    end
    it "is sorted in reverse-chronological order" do
      oldest = make_entry_with_date("2011-09-09") 
      newest = make_entry_with_date("2011-09-11") 
      middle = make_entry_with_date("2011-09-10") 
      @it.add_entry(oldest)
      @it.add_entry(newest) 
      @it.add_entry(middle) 
      @it.entries.must_equal([newest, middle, oldest])
    end
    it "is limited to 10 items" do
      10.times do |i| 
        @it.add_entry(make_entry_with_date("2011-09-#{i+1}"))
      end
      oldest = make_entry_with_date("2011-08-30") 
      @it.add_entry(oldest) 
      @it.entries.size.must_equal(10) 
      @it.entries.wont_include(oldest)
    end 
  end

end
