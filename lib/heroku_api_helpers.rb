module HerokuApiHelpers
  def self.default_headers(h = {})
    {
      authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
      accept: "application/vnd.heroku+json; version=3"
    }.merge(h)
  end
end
