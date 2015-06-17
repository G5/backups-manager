class AppWranglerWorker
  require "net/http"
  require 'net/https'
  require "uri"
  include Sidekiq::Worker

  def perform
    #::Wrangler.new() or something like this
  end

  class Wrangler
    def get_app_list
      app_list_uri = "https://api.heroku.com/apps"
      headers = { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
                   accept: "application/vnd.heroku+json; version=3",
                   range: "name ..; max=1000;"
                 }

      response = RestClient.get app_list_uri, headers
      data = JSON.parse response.body.to_json

      # Heroku returns up to 1000 records at a time. A response code 
      # of 206 means we only got a subset, so go back for more data.
      while response.code == 206
        headers[:range] = response.headers[:next_range]
        response = RestClient.get uri, headers
        next_batch = JSON.parse response.body.to_json
        data += next_batch
      end

      data
    end

    def get_app_details
      app_list = get_app_list

      app_list.each do |app|
        @addons = get_app_addons(app[0]["id"])
      end
    end

    def get_app_addons(uri)
    end

    def get_app_config_variables(uri)
    end

    def get_app_dynos(uri)
    end

    def get_app_domains(uri)
    end
  end

end