class AppsController < ApplicationController
  require "net/http"
  require 'net/https'
  require "uri"

  def index
    @tits = ENV['HEROKU_AUTH_TOKEN']

    uri = URI.parse("https://api.heroku.com/apps")
    http = Net::HTTPS.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)
    request["Authorization"] = "Bearer d8c43d64-b988-498f-a825-9d4448d3b294"
    request["Accept"] = "application/vnd.heroku+json; version=3"

    response = http.request(request)

    @tits=JSON.parse(response.body)

  end

  def show
  end
end
