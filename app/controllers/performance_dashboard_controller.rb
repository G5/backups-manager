class PerformanceDashboardController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!

  def index
    @new_relic_data = get_redis_data("newrelic:data")
    @goat = get_redis_data("pagerduty:oncall")
    @incidents = get_redis_data("pagerduty:incidents", "No Incidents at this time")

    #for real time incident hotness
    @new_incidents = new_incidents(@incidents, params["after"]) if params["after"]

    @unhealthy_apps = get_g5ops_data("g5ops:health")

    respond_to do |format|
      format.html
      format.js
      format.json
    end
  end


  def create
    PerformanceData.create_pagerduty_incident(params)
    render nothing: true
  end

  private

  def new_incidents(incidents, param)
    newbs = []
    incidents.delete(:error_status)
    incidents.each do |i|
      if i[1].is_a?(Hash) && i[1].has_key?("incident_number")
        newbs << i if i[1]["incident_number"] > param.to_i
      end
    end
    newbs
  end
end
