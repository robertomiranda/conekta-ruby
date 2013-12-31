require 'faraday'
require 'base64'
module Conekta
  class Requestor
    attr_reader :api_key
    def initialize()
      @api_key = Conekta.api_key
    end
    def api_url(url='')
      api_base = Conekta.api_base
      api_base + url
    end
    def request(meth, url, params=nil)
      url = self.api_url(url)
      meth = meth.downcase
#      begin
        conn = Faraday.new() do |faraday|
          faraday.adapter  Faraday.default_adapter
        end
        response = conn.method(meth).call do |req|
          req.url url
          req.headers['HTTP_AUTHORIZATION'] = "Basic #{ Base64.encode64("#{self.api_key}" + ':')}"
          req.headers['Accept'] = "application/vnd.conekta-v0.3.0+json"
          if params
            req.headers['Content-Type'] = 'application/json'
            req.body = params.to_json
          end
        end
        if response.status != 200
          Error.error_handler(JSON.parse(response.body), response.status)
        end
#      rescue
#      end
      return JSON.parse(response.body)
    end
    private
    def set_headers()
      return headers
    end
  end
end