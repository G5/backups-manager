class PerformanceDashboardController < ApplicationController
  def index
    @new_relic_data = $redis.get("newrelic:data") ? JSON.parse($redis.get("newrelic:data")) : "No Data Available."
    @goat = $redis.get("pagerduty:oncall") ? JSON.parse($redis.get("pagerduty:oncall")) : "No Data Available"
    @incidents = $redis.get("pagerduty:incidents") ? JSON.parse($redis.get("pagerduty:incidents")) : "No Data Available"
    @unhealthy_apps = $redis.get("g5ops:health") ? JSON.parse($redis.get("g5ops:health")) : "No Data Available"
    @unhealthy_app_count = "No Data Available"
    if @unhealthy_apps.is_a?(Hash)
      @unhealthy_apps = @unhealthy_apps.delete_if { |check| check.nil? }
      @unhealthy_app_count = @unhealthy_apps.count
    end
  end
end
