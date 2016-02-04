class AppTypesController < ApplicationController
  def index
    @q = App.ransack(params[:q])
    @apps = @q.result
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
