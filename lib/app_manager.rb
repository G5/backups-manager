class AppManager
  require "net/http"
  require 'net/https'
  require "uri"

  def initialize(app_name)
    @uri = "https://api.heroku.com/apps/#{app_name}"
    @headers = { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
                 accept: "application/vnd.heroku+json; version=3"
               }
  end

  def delete
    response = RestClient.delete @uri, @headers
    success = response.code == 200 ? true : false
  end

  def spin_down
    data = { updates: [ {process:"web", quantity: 0, size: "1X"}, {process:"worker", quantity: 0, size: "1X"} ] }
    @headers[:content_type] = 'application/json'
    response = RestClient.patch "#{@uri}/formation", data.to_json, @headers
    success = response.code == 200 ? true : false
  end

  def set_config_variable(var, val)
    data = {"#{var}": "#{val}"}
    @headers[:content_type] = 'application/json'
    response = RestClient.patch "#{@uri}/config-vars", data.to_json, @headers
    success = response.code == 200 ? true : false
  end
end
