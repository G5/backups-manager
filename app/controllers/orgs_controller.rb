class OrgsController < ApplicationController
  def index
    @organizations = Organization.includes(:apps).all
    @rate_limit = RateCheck.usage
  end
end
