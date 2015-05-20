class AppsController < ApplicationController
  caches_action :index, expires_in: 5.minutes

  def index
    @data = AppList.new().data
    @app_count = @data.length
    @rate_limit = RateCheck.new().usage
  end

  def show
    @app_name = params[:id]
    app = AppDetails.new(params[:id])

    @details = app.details
    @addons = app.addons
    @config_vars = app.config_vars
    @dynos = app.dynos
    @rate_limit = RateCheck.new().usage
  end
end
