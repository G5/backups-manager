class AppDetails
  require "net/http"
  require 'net/https'
  require "uri"

  def initialize(app_name)
    @uri = "https://api.heroku.com/apps/#{app_name}"
    @headers = { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
                 accept: "application/vnd.heroku+json; version=3"
               }
  end

  def details
    response = RestClient.get @uri, @headers
    data = JSON.parse response.body
  end

  def addons
    response = RestClient.get "#{@uri}/addons", @headers
    data = JSON.parse response.body
  end

  def config_vars
    response = RestClient.get "#{@uri}/config-vars", @headers
    data = JSON.parse response.body
  end

  def dynos
    response = RestClient.get "#{@uri}/formation", @headers
    data = JSON.parse response.body
  end

 
end