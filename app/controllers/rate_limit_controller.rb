class RateLimitController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @remaining = RateCheck.usage
  end

end
