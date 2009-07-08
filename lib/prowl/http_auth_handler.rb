class Prowl
  class HttpAuthHandler
    API_URL = URI.parse("https://prowl.weks.net:443/api/add_notification.php")
    
    def initialize(username, password)
      @username, @password = username, password
    end
    
    def valid?
      raise RuntimeError, "The API doesn't provide a method for determining if a username/password is valid."
    end
    
    def add(params)
      http = Net::HTTP.new(API_URL.host, API_URL.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      
      request = Net::HTTP::Get.new(API_URL.request_uri + "?" + params.map {|k, v| "#{k}=#{CGI.escape(v)}"}.join("&"))
      request.basic_auth @username, @password
      response = http.request(request)
      return response.code.to_i
    end
  end
end