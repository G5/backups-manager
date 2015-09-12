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

  private

  def get_detail(type)
    begin
      response = HTTPClient.get("#{uri}/#{type}", nil, HerokuApiHelpers.default_headers)
      JSON.parse response.body
    rescue => e
      e.response
    end
  end
end
