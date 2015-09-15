class CmsController < ApplicationController
  def index
    @cms_list = App.where("name LIKE ?", "%g5-cms%")
    @rate_limit = RateCheck.usage
  end
end
