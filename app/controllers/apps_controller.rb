class AppsController < ApplicationController

  def index
    @app_list = App.all
    @rate_limit = RateCheck.usage
  end

  def show
    @app = App.find params[:id]
    details = @app.app_details
    @app_name = @app.name
    @app_url = details["web_url"]
    @app_git_url = details["git_url"]
    @updated_at = details["updated_at"]
    @addons = @app.addons
    @config_vars = @app.config_variables
    @dynos = @app.dynos

    @domains = @app.domains if @app_name.include? "-clw-"

    @rate_limit = RateCheck.usage
  end

end
