class AppTypesController < ApplicationController
  def index
    @app_types = App.group_by_type(App.all)
    @rate_limit = RateCheck.usage
  end

  def show
    @type = params[:id]
    @apps = App.group_by_type(App.all)[@type]
    raise ActiveRecord::RecordNotFound.new("can't find apps of type '#{@type}'!") if @apps.blank?
    respond_to do |format|
      format.html
      format.txt
    end
  end
end
