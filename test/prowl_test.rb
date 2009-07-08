require 'test/unit'

$LOAD_PATH << File.expand_path("#{File.dirname(__FILE__)}/../lib")
require 'prowl'

require 'rubygems'
require 'mocha'

class ProwlTest < Test::Unit::TestCase
  def test_valid_api_key
    Prowl::ApiKeyHandler.any_instance.expects(:perform).returns(200)
    assert_equal 200, Prowl.send("my api key", :application => "Fishes", :event => "Silly", :description => "Blah")
  end
  
  # Uh.. Such a silly test.
  def test_invalid_api_key
    Prowl::ApiKeyHandler.any_instance.expects(:perform).returns(666)
    assert_equal 666, Prowl.send("my api key", :application => "Fishes", :event => "Silly", :description => "Blah")
  end
  
  def test_valid_with_api_key
    Prowl::ApiKeyHandler.any_instance.expects(:perform).returns(200)
    assert Prowl.verify("my api key")
    
    Prowl::ApiKeyHandler.any_instance.expects(:perform).returns(666)
    assert !Prowl.verify("my api key")
  end
  
  def test_http_auth
    Prowl::HttpAuthHandler.any_instance.expects(:add).returns(200)
    assert_equal 200, Prowl.send("username", "password", :application => "Fishes", :event => "Silly", :description => "Blah")
  end
  
  # Also uh..
  def test_failed_http_auth
    Prowl::HttpAuthHandler.any_instance.expects(:add).returns(666)
    assert_equal 666, Prowl.send("username", "password", :application => "Fishes", :event => "Silly", :description => "Blah")
  end
  
  def test_valid_with_username_and_password
    assert_raises(RuntimeError) { Prowl.new("username", "password").valid? }
  end
end