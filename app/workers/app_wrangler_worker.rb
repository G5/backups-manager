class AppWranglerWorker
  require "net/http"
  require 'net/https'
  require "uri"
  include Sidekiq::Worker

  def perform
    create_apps
  end

  def create_apps
    app_list = get_app_list
    app_list.each do |app|
      dynos = get_app_dynos(app["name"])
      addons = get_app_addons(app["name"])
      config_vars = get_app_config_variables(app["name"])
      domains = get_app_domains(app["name"])
      attributes = {app_details: app_list, dynos: dynos, addons: addons, config_variables: config_vars, domains: domains}
      App.create(attributes)
    end
  end

  def get_app_list
    app_list_uri = "https://api.heroku.com/apps"
    headers = create_headers 
    response = RestClient.get app_list_uri, headers
    data = JSON.parse response.body.to_json
    # Heroku returns up to 1000 records at a time. A response code 
    # of 206 means we only got a subset, so go back for more data.
    while response.code == 206
      headers[:range] = response.headers[:next_range].gsub("]", "..")
      response = RestClient.get app_list_uri, headers
      next_batch = JSON.parse response.body
      data += next_batch
    end

    data
  end

  def get_app_dynos(name)
    headers = { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
                 accept: "application/vnd.heroku+json; version=3"
               }
    response = RestClient.get "https://api.heroku.com/apps/#{name}/formation", headers
    data = JSON.parse response.body.to_json
  end

  def get_app_addons(name)
    headers = { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
                 accept: "application/vnd.heroku+json; version=3"
               }
    response = RestClient.get "https://api.heroku.com/apps/#{name}/addons", headers
    data = JSON.parse response.body.to_json
  end

  def get_app_config_variables(name)
    headers = { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
                 accept: "application/vnd.heroku+json; version=3"
               }
    response = RestClient.get "https://api.heroku.com/apps/#{name}/config-vars", headers
    data = JSON.parse response.body.to_json
  end

  def get_app_domains(name)
    headers = { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
                 accept: "application/vnd.heroku+json; version=3"
               }
    response = RestClient.get "https://api.heroku.com/apps/#{name}/domains", headers
    data = JSON.parse response.body.to_json
  end

  def create_headers
    headers = { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
                 accept: "application/vnd.heroku+json; version=3",
                 range: "name ..; max=1000;"
               }
  end

end