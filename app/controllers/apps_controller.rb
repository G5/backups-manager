class AppsController < ApplicationController
  def index
    @data = AppList.new().data
    @app_count = @data.length
  end

  def show
  end
end
