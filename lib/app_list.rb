class AppList
  require "net/http"
  require 'net/https'
  require "uri"

  def initialize
    @uri = "https://api.heroku.com/apps"
    @headers = { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
                 accept: "application/vnd.heroku+json; version=3",
                 range: "name ..; max=1000;"
               }
  end

  def data
    response = RestClient.get @uri, @headers

    data = JSON.parse response.body

    # Heroku returns up to 1000 records at a time. A response code 
    # of 206 means we only got a subset, so go back for more data.
    while response.code == 206
      @headers[:range] = response.headers[:next_range]
      response = RestClient.get @uri, @headers
      next_batch = JSON.parse response.body
      data += next_batch
    end

    data
  end
  
end