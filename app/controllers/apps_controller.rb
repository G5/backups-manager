class AppsController < ApplicationController
  require "net/http"
  require 'net/https'
  require "uri"

  def index
    response = RestClient.get "https://api.heroku.com/apps", :authorization => "Bearer #{ENV['HEROKU_AUTH_TOKEN']}", :accept => "application/vnd.heroku+json; version=3"

    @data = JSON.parse(response.body)

  end

  def show
  end
end
