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
      unless app["reporting"] == false
        redis.set("new_relic_#{app["id"]}", 
                  [app["name"],
                   app["health_status"],
                   app["application_summary"]["response_time"],
                   app["application_summary"]["apdex_score"],
                   app["application_summary"]["error_rate"]
        ].to_json)
      end
    end
  end

  def pagerduty_oncall
    data = PerformanceData.get_pagerduty_oncall("https://ey-g5search.pagerduty.com/api/v1/escalation_policies/on_call")
    data["escalation_policies"][0]["on_call"].each do |goat|
      redis.set("pager_duty_level_#{goat["level"]}",
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
                  inci["trigger_summary_data"]["description"]
      ].to_json)
    end
  end

  private

  def redis
    @redis ||= Redis.new
  end
end
