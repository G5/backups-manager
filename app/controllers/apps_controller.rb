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

    Resque.enqueue(AppDelete, @app_name)

    @message = "#{@app_name} has been queued for deletion."
  end

end
