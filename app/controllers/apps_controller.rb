class AppsController < ApplicationController
  def index
    @data = AppList.new().data
    @app_count = @data.length
  end

  def show
    @app_name = params[:id]
    app = AppDetails.new(params[:id])

    @details = app.details
    @addons = app.addons
    @config_vars = app.config_vars

    # render json: @config_vars
    
  end
end
