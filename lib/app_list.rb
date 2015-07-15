class AppList
  def self.get
    app_list_uri = "https://api.heroku.com/apps"
    headers = default_headers 
    response = HTTPClient.get app_list_uri, nil, headers
    data = JSON.parse response.body
    # Heroku returns up to 1000 records at a time. A response code 
    # of 206 means we only got a subset, so go back for more data.
    while response.code == 206
      headers[:range] = response.headers["Next-Range"].gsub("]", "..")
      response = HTTPClient.get app_list_uri, nil, headers
      next_batch = JSON.parse response.body
      data += next_batch
      binding.pry
    end

    data
  end
  
  def self.default_headers
    { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
      accept: "application/vnd.heroku+json; version=3",
      range: "name ..; max=1000;" }
  end
end
