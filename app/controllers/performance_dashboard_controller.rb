class PerformanceDashboardController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!

  def index
    @new_relic_data = get_redis_data("newrelic:data")
    @goat = get_redis_data("pagerduty:oncall")
    @incidents = get_redis_data("pagerduty:incidents", "No Incidents at this time")
    @unhealthy_apps = get_g5ops_data("g5ops:health")
  end


  def create
    PerformanceData.pagerduty_incidents(params)
  end
end
