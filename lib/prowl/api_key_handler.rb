class Prowl
  class ApiKeyHandler
    API_URL = "https://prowl.weks.net:443/publicapi"
    
    def initialize(api_key)
      @api_key = api_key
    end
    
    def valid?
      @valid ||= (perform("verify", :apikey => @api_key) == 200)
    end
    
    def add(params)
      perform("add", params)
    end
    
    private
    
    def perform(action, params)
      uri = URI.parse("#{API_URL}/#{action}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      
      params[:apikey] = @api_key
      request = Net::HTTP::Get.new(uri.request_uri + "?" + params.map {|k, v| "#{k}=#{CGI.escape(v)}"}.join("&"))
      response = http.request(request)
      return response.code.to_i
    end
  end
end