class AppsController < ApplicationController
  caches_action :index, expires_in: 5.minutes

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
    @dynos = app.dynos
  end

  def destroy
    @app_name = params[:id]
    app = AppDetails.new(params[:id])
    success = app.delete
    @message = success ? "#{@app_name} has been deleted." : "There was a problem, and #{@app_name} was not deleted."
  end

end
