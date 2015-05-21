class RateLimitController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @remaining = RateCheck.new().usage
  end

end
