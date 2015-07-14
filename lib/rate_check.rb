class RateCheck
  URI = "https://api.heroku.com/account/rate-limits"

  def self.usage
    response = HTTPClient.get URI, nil, default_headers
    data = JSON.parse response.body
    data["remaining"]
  end

  def self.default_headers
    { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
      accept: "application/vnd.heroku+json; version=3" }
  end
end
