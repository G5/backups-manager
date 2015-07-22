class OrgsController < ApplicationController
  def index
    @app_list = App.all
    @rate_limit = RateCheck.usage
  end
end
