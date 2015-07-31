class RealTimeAppsController < ApplicationController
  def index
    @app_list = AppList.sorted

    # Need to clean this up. Duplicated over in the OrgsController
    zone = ActiveSupport::TimeZone.new("Pacific Time (US & Canada)")
    @time = Time.now.in_time_zone(zone).strftime("%I:%M%p")

    respond_to do |format|
      format.html
      format.json { render json: AppList.new.make_app_array.as_json }
    end
  end

  def show
  end
end
