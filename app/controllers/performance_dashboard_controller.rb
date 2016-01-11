class PerformanceDashboardController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!

  def index
    @new_relic_data = get_redis_data("newrelic:data")
    @goat = get_redis_data("pagerduty:oncall")
    @incidents = get_redis_data("pagerduty:incidents", "No Incidents at this time")

    @unhealthy_apps = get_g5ops_data("g5ops:health")

    respond_to do |format|
      format.html
      format.json
    end
  end


  def create
    PerformanceData.create_pagerduty_incident(params)
    render nothing: true
  end

  private

  def get_redis_data(key, status_message="Data is currently unavailable.")
    if key == "pagerduty:incidents"
      if pagerduty_redis_incidents.present?
        incident_keys = pagerduty_redis_incidents.reverse
        incidents = Hash[status_message: false]
        incident_keys.each do |pd_key|
          inci_hash = { "#{pd_key}" => JSON.parse($redis.get(pd_key)) }
          incidents.merge!(inci_hash)
        end
        return incidents
      else
        return Hash[status_message: "YeeHaw! No Incidents!"]
      end
    else
      ($redis.get(key) && JSON.parse($redis.get(key)).present?) ? Hash[status_message: false, data: JSON.parse($redis.get(key))] : Hash[status_message: status_message]
    end
  end

  def get_g5ops_data(key)
    ops_health_hash = {}
    if get_redis_data(key).is_a?(Array)
      ops_health_hash[:unhealthy_apps] = get_redis_data(key)
      ops_health_hash[:unhealthy_apps_count] = ops_health_hash[:unhealthy_apps].count
      ops_health_hash[:error_status] = false
    else
      ops_health_hash[:error_status] = true
      ops_health_hash[:error_message] =  "Data is currently unavailable."
      ops_health_hash[:unhealthy_apps] = get_redis_data(key)
    end
  end

  def pagerduty_redis_incidents
    $redis.keys.select { |key| key.include?("pagerduty:incidents") }
  end
end
