class AppsController < ApplicationController
  def index
    @q = App.ransack(params[:q])
    @apps = @q.result.includes(:organization)
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
