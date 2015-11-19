class PerformanceDashboardController < ApplicationController
  def index
    @no_data_message = "No Data Available"
    @new_relic_data = $redis.get("newrelic:data") ? JSON.parse($redis.get("newrelic:data")) : @no_data_message
    @goat = $redis.get("pagerduty:oncall") ? JSON.parse($redis.get("pagerduty:oncall")) : @no_data_message
    @incidents = $redis.get("pagerduty:incidents") ? JSON.parse($redis.get("pagerduty:incidents")) : @no_data_message
    @unhealthy_apps = $redis.get("g5ops:health") ? JSON.parse($redis.get("g5ops:health")) : @no_data_message
    @unhealthy_app_count = @no_data_message
    if @unhealthy_apps.is_a?(Array)
      @unhealthy_apps = @unhealthy_apps.delete_if { |check| check.nil? }
      @unhealthy_app_count = @unhealthy_apps.count
    end
  end
end
