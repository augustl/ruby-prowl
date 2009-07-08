require 'cgi'
require 'net/https'
require 'uri'

require 'prowl/api_key_handler'
require 'prowl/http_auth_handler'

class Prowl
  # new('username', 'password') or new('apikeyhere').
  def initialize(*args)
    case args.length
    when 1 # api key
      @handler = Prowl::ApiKeyHandler.new(*args)
    when 2 # username/password
      @handler = Prowl::HttpAuthHandler.new(*args)
    else
      raise ArgumentError
    end
  end
  
  def send(params)
    @handler.add(params)
  end
  
  # Utility function that creates an instance and sends a prowl
  def self.send(*args)
    params = args.pop
    new(*args).send(params)
  end
  
  # Utility function to verify API keys
  def self.verify(api_key)
    new(api_key).valid?
  end
  
  def valid?
    @handler.valid?
  end
end

# For me and my good friend friend Textmate.
if __FILE__ == $0
  puts "Your API key, please."
  api_key = gets
  
  if api_key
    api_key.chomp!
    p Prowl.send(api_key, :application => "Fishes", :event => "silly", :description => "Awwawaw.")
  end
  
  
  puts "Test verification?"
  api_key = gets
  
  if api_key
    api_key.chomp!
    p Prowl.new(api_key).valid?
  end
  
  puts "Your username, please."
  username = gets.chomp
  
  puts "Your password, please."
  password = gets.chomp
  
  if username
    username.chomp!
    password.chomp!
    p Prowl.send(username, password, :application => "Fishes", :event => "silly", :description => "Awwawaw.")
  end
end