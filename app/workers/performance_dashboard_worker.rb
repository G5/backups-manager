class PerformanceDashboardWorker 
  include Sidekiq::Worker
  include WorkersHelper

  def perform
   new_relic_data
  end

  def new_relic_data
    data = PerformanceData.get_new_relic_data("https://api.newrelic.com/v2/applications.json")
    data["applications"].each do |app|
      redis.set(app["id"], [app["name"], app["health_status"], app["end_user_summary"]["response_time"]].to_json)
    end
  end

  def pagerduty_oncall
    PerformanceData.get_pagerduty_oncall("https://ey-g5search.pagerduty.com/api/v1/escalation_policies/on_call")
  end

  def pagerduty_incidents
    PerformanceData.get_pagerduty_incidents("https://ey-g5search.pagerduty.com/api/v1/incidents")
  end

  private

  def redis
    @redis ||= Redis.new
  end
end
