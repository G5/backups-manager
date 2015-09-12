class RateCheck
  URI = "https://api.heroku.com/account/rate-limits"

  def self.usage
    response = HTTPClient.get URI, nil, HerokuApiHelpers.default_headers
    data = JSON.parse response.body
    data["remaining"]
  end
end
