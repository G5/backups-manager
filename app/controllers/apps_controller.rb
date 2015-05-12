class AppsController < ApplicationController
  require "net/http"
  require 'net/https'
  require "uri"

  def index
    uri = "https://api.heroku.com/apps"
    headers = { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
                accept: "application/vnd.heroku+json; version=3",
                range: "name ..; max=1000;"
              }
    response = RestClient.get uri, headers

    data = JSON.parse response.body



    while response.code == 206
      headers[:range] = response.headers[:next_range]
      response = RestClient.get uri, headers
      next_batch = JSON.parse response.body
      data += next_batch
    end
  
    @data = data
    @app_count = data.length
    # @data = data.group_by { |app| app["owner"]["email"] }
    # @data = @data.sort_by{|i| i[0]}
    # @org_count = @data.length

  end

  def show
  end
end
