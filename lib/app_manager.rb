class AppManager
  require "net/http"
  require 'net/https'
  require "uri"

  def initialize(app_name)
    @uri = "https://api.heroku.com/apps/#{app_name}"
    @headers = HerokuApiHelpers.default_headers(content_type: "application/json")
  end

  def delete
    response = RestClient.delete(@uri, HerokuApiHelpers.default_headers)
    response.code == 200
  end

  def spin_down
    data = { updates: [ {process:"web", quantity: 0, size: "1X"}, {process:"worker", quantity: 0, size: "1X"} ] }
    response = RestClient.patch "#{@uri}/formation", data.to_json, @headers
    response.code == 200
  end

  def set_config_variable(var, val)
    data = {"#{var}": "#{val}"}
    response = RestClient.patch "#{@uri}/config-vars", data.to_json, @headers
    response.code == 200
  end
end
