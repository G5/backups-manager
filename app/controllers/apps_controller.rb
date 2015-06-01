class AppsController < ApplicationController
  caches_action :index, expires_in: 5.minutes

  def index
    @app_list = AppList.new()
    @data = @app_list.data
    @app_count = @data.length
    @rate_limit = RateCheck.new().usage

    # Need to clean this up. Duplicated over in the OrgsController
    zone = ActiveSupport::TimeZone.new("Pacific Time (US & Canada)")
    @time = Time.now.in_time_zone(zone).strftime("%I:%M%p")

    respond_to do |format|
      format.html
      format.json { render json: AppList.new.make_app_array.as_json }
    end
  end

  def show
    @app_name = params[:id]
    app = AppDetails.new(params[:id])

    @details = app.details
    @addons = app.addons
    @config_vars = app.config_vars
    @dynos = app.dynos

    if @app_name.include? "-clw-"
      @domains = app.domains
    end

    @rate_limit = RateCheck.new().usage
  end
end
