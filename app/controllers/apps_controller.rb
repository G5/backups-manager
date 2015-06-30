class AppsController < ApplicationController
  # caches_action :index, expires_in: 5.minutes

  def index
    @app_list = App.all
    @app_count = @app_list.count
    @rate_limit = RateCheck.new().usage

    # Need to clean this up. Duplicated over in the OrgsController
    zone = ActiveSupport::TimeZone.new("Pacific Time (US & Canada)")
    @time = Time.now.in_time_zone(zone).strftime("%I:%M%p")

    respond_to do |format|
      format.html
      format.json { render json: App.all.make_app_array.as_json }
    end
  end

  def show
    @app = App.find params[:id]
    details = @app.app_details
    @app_name = @app.name
    @app_url = details["web_url"]
    @app_git_url = details["git_url"]
    @updated_at = details["updated_at"]
    @addons = @app.addons
    @config_vars = @app.config_variables
    @dynos = @app.dynos

    @domains = @app.domains if @app_name.include? "-clw-"

    @rate_limit = RateCheck.new().usage
  end

end
