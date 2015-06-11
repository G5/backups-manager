class OrgsController < ApplicationController
  caches_action :index, expires_in: 5.minutes

  def index
    data = AppList.new().data
    @app_count = data.length
    @data = data.group_by { |app| app["owner"]["email"].gsub("@herokumanager.com", "") }
    @data = @data.sort_by{|i| i[0]}
    @org_count = @data.length
    @rate_limit = RateCheck.new().usage

    # Need to clean this up. Duplicated over in the AppsController
    zone = ActiveSupport::TimeZone.new("Pacific Time (US & Canada)")
    @time = Time.now.in_time_zone(zone).strftime("%I:%M%p")
  end
end
