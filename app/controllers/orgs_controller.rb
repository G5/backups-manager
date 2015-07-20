class OrgsController < ApplicationController
  def index
    @app_list = App.all
    @app_count = @app_list.count
    @data = @app_list.group_by { |app| app.app_details["owner"]["email"].gsub("@herokumanager.com", "") }
    @grouped_apps = @data.sort_by{|i| i[0]}
    @rate_limit = RateCheck.usage
  end
end
