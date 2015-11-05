class PerformanceDashboardWorker 
  include Sidekiq::Worker
  include WorkersHelper

  def perform
   new_relic_data
   pagerduty_oncall
   pagerduty_incidents
  end

  def new_relic_data
    data = PerformanceData.get_new_relic_data("https://api.newrelic.com/v2/applications.json")
    data["applications"].each do |app|
      redis.set(app["id"], 
                [app["name"],
                 app["health_status"],
                 app["application_summary"]["response_time"],
                 app["application_summary"]["apdex_score"],
                 app["application_summary"]["error_rate"]
                ].to_json)
    end
  end

  def pagerduty_oncall
    data = PerformanceData.get_pagerduty_oncall("https://ey-g5search.pagerduty.com/api/v1/escalation_policies/on_call")
    data["on_call"].each do |goat|
      redis.set(goat["user"]["id"],
                [goat["user"]["name"],
                 goat["level"],
                 goat["start"],
                 goat["end"]
                ].to_json)
    end
  end

  def pagerduty_incidents
    data = PerformanceData.get_pagerduty_incidents("https://ey-g5search.pagerduty.com/api/v1/incidents")
    data["incidents"].each do |inci|
      redis.set("pagerduty_incident_#{inci["incident_number"]}",
                [
                  inci["status"],
                  inci["created_on"],
                  inci["service"]["name"],
                  inci["assigned_to_user"]["name"]
      ].to_json)
    end
  end

  private

  def redis
    @redis ||= Redis.new
  end
end
