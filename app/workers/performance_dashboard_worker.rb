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
    apps = data["applications"].map do |app|
      unless app["reporting"] == false
        {
          id: app["id"],
          name: app["name"],
          health_status: app["health_status"],
          response_time: app["application_summary"]["response_time"],
          apdex_score: app["application_summary"]["apdex_score"],
          error_rate: app["application_summary"]["error_rate"]
        }
      end
    end
    redis.set("newrelic:data", apps.to_json)
  end

  def pagerduty_oncall
    data = PerformanceData.get_pagerduty_oncall("https://ey-g5search.pagerduty.com/api/v1/escalation_policies/on_call")
    oncall = data["escalation_policies"][0]["on_call"].map do |goat|
      {
        user: goat["user"]["name"],
        level: goat["level"],
        start_date_time: goat["start"],
        end_date_time: goat["end"]
      }
    end
    redis.set("pagerduty:oncall", oncall.to_json)
  end

  def pagerduty_incidents
    data = PerformanceData.get_pagerduty_incidents("https://ey-g5search.pagerduty.com/api/v1/incidents")
    incidents = data["incidents"].map do |inci|
      {
        incident_number: inci["incident_number"]
        status: inci["status"],
        created_at: inci["created_on"],
        description: inci["trigger_summary_data"]["description"]
      }
    end
    redis.set("pagerduty:incidents", incidents.to_json)
  end


  private

  def redis
    @redis ||= Redis.new
  end
end
