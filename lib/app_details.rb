class AppDetails
  attr_reader :uri
  
  def initialize(name)
    @uri = "https://api.heroku.com/apps/#{name}"
  end

  def get_app_dynos
    get_detail("formation")
  end

  def get_app_addons
    get_detail("addons")
  end

  def get_app_config_variables
    get_detail("config-vars")
  end

  def get_app_domains
    get_detail("domains")
  end

  def self.default_headers
    { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
      accept: "application/vnd.heroku+json; version=3" }
  end

  def delete
    response = HTTPClient.delete uri, nil, header
    success = response.code == 200 ? true : false
  end

  def spin_down
    data = { updates: [ { process:"web", quantity: 0, size: "1X"}, { process:"worker", quantity: 0, size: "1X"} ] }
    @headers[:content_type] = 'application/json'
    response = HTTPClient.request(:patch, "#{uri}/formation", nil, data.to_json, header)

    success = response.code == 200 ? true : false
  end

  private

  def get_detail(type)
    begin
      response = HTTPClient.get "#{uri}/#{type}", nil, AppDetails.default_headers
      data = JSON.parse response.body
    rescue => e
      e.response
    end
  end
end