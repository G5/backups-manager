class RateLimitController < ApplicationController

  def index
    @remaining = RateCheck.new().usage
  end

end
