class LiveSummariesController < ApplicationController
  def index
    @app = App.find params[:app_id]
    @app_dynos = AppDetails.new(@app.name).get_app_dynos
  end

end