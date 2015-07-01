class OrgsController < ApplicationController
  def index
    @app_list = App.all
    @app_count = @app_list.count
    @data = @app_list.group_by { |app| app.app_details["owner"]["email"].gsub("@herokumanager.com", "") }
    @grouped_apps = @data.sort_by{|i| i[0]}
    @rate_limit = RateCheck.new().usage

    # Need to clean this up. Duplicated over in the AppsController
    zone = ActiveSupport::TimeZone.new("Pacific Time (US & Canada)")
    @time = Time.now.in_time_zone(zone).strftime("%I:%M%p")
  end
end
