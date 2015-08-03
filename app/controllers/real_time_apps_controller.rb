class RealTimeAppsController < ApplicationController
  def index
    @app_list = AppList.sorted

    respond_to do |format|
      format.html
      format.json { render json: stripped_app_list.as_json }
    end
  end

  def show
  end

  private

  def stripped_app_list
    stripped_list = {}
    @app_list.each do |app_type, app_details|
      stripped_list[app_type.to_sym] = []
      @app_list[app_type.to_sym].each do |app|
        stripped_list[app_type] << app["name"]
      end
    end
    stripped_list
  end

end
