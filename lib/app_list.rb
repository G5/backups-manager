class AppList
  require "net/http"
  require 'net/https'
  require "uri"

  def get_app_list
    app_list_uri = "https://api.heroku.com/apps"
    headers = create_headers 
    response = RestClient.get app_list_uri, headers
    data = JSON.parse response.body
    # Heroku returns up to 1000 records at a time. A response code 
    # of 206 means we only got a subset, so go back for more data.
    while response.code == 206
      headers[:range] = response.headers[:next_range].gsub("]", "..")
      response = RestClient.get app_list_uri, headers
      next_batch = JSON.parse response.body
      data += next_batch
    end

    data
  end

  def create_headers
    headers = { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
                 accept: "application/vnd.heroku+json; version=3",
                 range: "name ..; max=1000;"
               }
  end
end