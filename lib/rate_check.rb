class RateCheck
  require "net/http"
  require 'net/https'
  require "uri"

  def initialize
    @uri = "https://api.heroku.com/account/rate-limits"
    @headers = { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
                 accept: "application/vnd.heroku+json; version=3"
               }
  end

  def usage
    response = HTTPClient.get @uri, nil, @headers
    data = JSON.parse response.body
    data["remaining"]
  end
end