require 'cgi'
require 'net/https'
require 'uri'


class Prowl
  class MissingAPIKey < RuntimeError; end
  class TooManyAPIKeys < RuntimeError; end
  class PriorityOutOfRange < RuntimeError; end
  
  API_URL = "https://api.prowlapp.com/publicapi"
  MAX_API_KEYS = 5
  PRIORITY_RANGE = -2..2
  
  def initialize(defaults = {})
    @defaults = defaults
  end

  def set_proxy(addr, port)
    @proxy_addr = addr
    @proxy_port = port
  end
  
  def add(params = {})
    perform("add", params)
  end
  
  # Modify this instance's defaults
  def defaults(params)
    @defaults = @defaults.merge(params)
  end
  
  def valid?
    @valid ||= (perform("verify") == 200)
  end
  
  # Utility function that creates an instance and sends a prowl
  def self.add(params = {})
    new(params).add
  end
  
  # Utility function to verify API keys
  def self.verify(apikey)
    new({:apikey => apikey}).valid?
  end
  
  private
  
  def perform(action, params = {})
    # Merge the default params with any custom ones
    unless !@defaults
      params = @defaults.merge(params)
    end
    
    if !params[:apikey] || (params[:apikey].is_a?(Array) && params[:apikey].size < 1)
      raise MissingAPIKey
    end
    
    # Raise an exception if we're trying to use more API keys than allowed for this action
    if params[:apikey].is_a?(Array) && ((action == "verify" && params[:apikey].size > 1) || params[:apikey].size > MAX_API_KEYS)
      raise TooManyAPIKeys
    end
    
    if params[:priority] && !PRIORITY_RANGE.include?(params[:priority])
      raise PriorityOutOfRange
    end
    
    # If there are multiple API Keys in an array, merge them into a comma-delimited string
    if params[:apikey].is_a?(Array)
      params[:apikey] = params[:apikey].join(",")
    end
    
    uri = URI.parse("#{API_URL}/#{action}")

    proxy = Net::HTTP::Proxy(@proxy_addr, @proxy_port)
    http = proxy.start(uri.host, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE)
    
    request = Net::HTTP::Get.new(uri.request_uri + "?" + params.map {|k, v| "#{k}=#{CGI.escape(v.to_s)}"}.join("&"))
    response = http.request(request)
    return response.code.to_i
  end
end

# For me and my good friend friend Textmate.
if __FILE__ == $0
  api_key = "change me"
  
  p Prowl.add(:apikey => api_key, :application => "Fishes", :event => "silly", :description => "Awwawaw.", :priority => 1)
  p Prowl.verify(api_key)
end
