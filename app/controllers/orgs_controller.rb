class OrgsController < ApplicationController
  def index
    data = AppList.new().data
    @app_count = data.length
    @data = data.group_by { |app| app["owner"]["email"].gsub("@herokumanager.com", "") }
    @data = @data.sort_by{|i| i[0]}
    @org_count = @data.length
  end
end
