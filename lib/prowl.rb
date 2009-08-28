require 'cgi'
require 'net/https'
require 'uri'


class Prowl
  class MissingAPIKey < RuntimeError; end
  class PriorityOutOfRange < RuntimeError; end
  
  API_URL = "https://prowl.weks.net:443/publicapi"
  PRIORITY_RANGE = -2..2
  
  def initialize(api_key)
    @api_key = api_key
  end
  
  def add(params = {})
    perform("add", params)
  end
  
  def valid?
    @valid ||= (perform("verify") == 200)
  end
  
  # Utility function that creates an instance and sends a prowl
  def self.add(api_key, params = {})
    new(api_key).add(params)
  end
  
  # Utility function to verify API keys
  def self.verify(api_key)
    new(api_key).valid?
  end
  
  private
  
  def perform(action, params)
    if !@api_key
      raise MissingAPIKey
    end
    
    if params[:priority] && !PRIORITY_RANGE.include?(params[:priority])
      raise PriorityOutOfRange
    end
    
    params[:apikey] = @api_key
    
    uri = URI.parse("#{API_URL}/#{action}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    request = Net::HTTP::Get.new(uri.request_uri + "?" + params.map {|k, v| "#{k}=#{CGI.escape(v.to_s)}"}.join("&"))
    response = http.request(request)
    return response.code.to_i
  end
end

# For me and my good friend friend Textmate.
if __FILE__ == $0
  api_key = "change me"
  
  p Prowl.add(api_key, :application => "Fishes", :event => "silly", :description => "Awwawaw.", :priority => 1)
  p Prowl.new(api_key).valid?
end