  class AppDetails
  require "net/http"
  require 'net/https'
  require "uri"

  attr_reader :uri, :header
  
  def initialize(name)
    @header = { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
                 accept: "application/vnd.heroku+json; version=3"
               }

    @uri = "https://api.heroku.com/apps/#{name}"
  end

  def get_app_dynos
    begin
      response = HTTPClient.get "#{uri}/formation", nil, header
      data = JSON.parse response.body
    rescue => e
      e.response
    end
  end

  def get_app_addons
    begin
      response = HTTPClient.get "#{uri}/addons", nil, header
      data = JSON.parse response.body
    rescue => e
      e.response
    end
  end

  def get_app_config_variables
    begin
      response = HTTPClient.get "#{uri}/config-vars", nil, header
      data = JSON.parse response.body
    rescue => e
      e.response
    end
  end

  def get_app_domains
    begin
      response = HTTPClient.get "#{uri}/domains", nil, header
      data = JSON.parse response.body
    rescue => e
      e.response
    end
  end

  def delete
    response = HTTPClient.delete uri, nil, header
    success = response.code == 200 ? true : false
  end

  def spin_down
    data = { updates: [ { process:"web", quantity: 0, size: "1X"}, { process:"worker", quantity: 0, size: "1X"} ] }
    @headers[:content_type] = 'application/json'
    response = HTTPClient.patch "#{uri}/formation", data.to_json, nil, header

    success = response.code == 200 ? true : false
  end
end