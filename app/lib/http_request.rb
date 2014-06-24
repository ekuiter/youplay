module HttpRequest
  def self.http_request(data) # data {:url[[, post: {"name" => "value"}[, :user, :pass]]}
    ca_file = 'lib/cacert.pem' # ssl certificate data from: http://curl.haxx.se/ca/cacert.pem
    require 'net/http'
    require 'uri'
    uri = URI.parse data[:url]
    if data[:post].blank? # get requests
      http = Net::HTTP.new uri.host, uri.port
      if uri.class.to_s == 'URI::HTTPS'
        http.use_ssl = true
        http.ca_file = ca_file
      end
      request = Net::HTTP::Get.new uri.request_uri
      if !data[:user].blank? && !data[:pass].blank? then # use authentication if needed
        request.basic_auth data[:user], data[:pass]
      end
      response = http.request request
    else # post requests
      http = Net::HTTP.new uri.host, uri.port
      if uri.class.to_s == 'URI::HTTPS'
        http.use_ssl = true
        http.ca_file = ca_file
      end
      request = Net::HTTP::Post.new uri.request_uri
      if !data[:user].blank? && !data[:pass].blank? then # use authentication if needed
        request.basic_auth data[:user], data[:pass]
      end
      request.set_form_data data[:post] # add post data
      response = http.request request
    end
    response
  end
end