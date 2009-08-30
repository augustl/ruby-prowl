require 'test/unit'

$LOAD_PATH << File.expand_path("#{File.dirname(__FILE__)}/../lib")
require 'prowl'

require 'rubygems'
require 'mocha'

class ProwlTest < Test::Unit::TestCase
  def test_not_without_an_api_key
    assert_raises(Prowl::MissingAPIKey) { Prowl.add(:apikey => nil) }
  end
  
  def test_invalid_priority
    assert_raises(Prowl::PriorityOutOfRange) { Prowl.add(:apikey => "foo", :priority => 10)}
  end
  
  def test_valid_api_key
    Prowl.any_instance.expects(:perform).returns(200)
    assert_equal 200, Prowl.add(:apikey => "my api key", :application => "Fishes", :event => "Silly", :description => "Blah")
  end
  
  # Uh.. Such a silly test.
  def test_invalid_api_key
    Prowl.any_instance.expects(:perform).returns(666)
    assert_equal 666, Prowl.add(:apikey => "my api key", :application => "Fishes", :event => "Silly", :description => "Blah")
  end
  
  def test_verify_with_api_key
    Prowl.any_instance.expects(:perform).returns(200)
    assert Prowl.verify("my api key")
    
    Prowl.any_instance.expects(:perform).returns(666)
    assert !Prowl.verify("my api key")
  end
end