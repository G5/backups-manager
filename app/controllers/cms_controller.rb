class CmsController < ApplicationController
  def index
    @app_list = App.all
    @cms_list = @app_list.select { |a| a.name[/g5-cms-/] }
    @rate_limit = RateCheck.usage
  end
end
