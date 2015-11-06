class PerformanceDashboardController < ApplicationController
  def index 
    redis ||= Redis.new
    @new_relic_data = JSON.parse(redis.get("newrelic:data"))
    @goat = JSON.parse(redis.get("pagerduty:oncall"))
    @incidents = JSON.parse(redis.get("pagerduty:incidents"))
  end
end
