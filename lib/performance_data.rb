class PerformanceData
  def self.new_relic_data
    data = self.get_new_relic_data("https://api.newrelic.com/v2/applications.json")
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
    $redis.set("newrelic:data", apps.to_json)
  end

  def self.pagerduty_oncall
    data = self.get_pagerduty_oncall("https://ey-g5search.pagerduty.com/api/v1/escalation_policies/on_call")
    oncall = data["escalation_policies"][0]["on_call"].map do |goat|
      {
        user: goat["user"]["name"],
        level: goat["level"],
        start_date_time: goat["start"],
        end_date_time: goat["end"]
      }
    end
    $redis.set("pagerduty:oncall", oncall.to_json)
  end

  def self.pagerduty_incidents
    data = self.get_pagerduty_incidents("https://ey-g5search.pagerduty.com/api/v1/incidents")
    incidents = data["incidents"].map do |inci|
      {
        incident_number: inci["incident_number"],
        status: inci["status"],
        created_at: inci["created_on"],
        description: inci["trigger_summary_data"]["description"]
      }
    end
    $redis.set("pagerduty:incidents", incidents.to_json)
  end

  def self.get_new_relic_data(uri)
    begin
      response = HTTPClient.
        get(uri, nil, { "X-Api-Key" => ENV['NEW_RELIC_API_KEY'] })
      JSON.parse response.body
    rescue => e
      e.response
    end
  end

  def self.get_pagerduty_oncall(uri)
    begin
      response = HTTPClient.
        get(uri,
            nil,
            {
              "Content-type" => "application/json",
              "Authorization" => "Token token=#{ENV['PAGER_DUTY_API_KEY']}"
            }
        )
        JSON.parse response.body
    rescue => e
      e.response
    end
  end

  def self.get_pagerduty_incidents(uri)
    begin
      response = HTTPClient.
        get(uri,
            {"status"=>"triggered,acknowledged"},
            {
              "Content-type" => "application/json",
              "Authorization" => "Token token=#{ENV['PAGER_DUTY_API_KEY']}"
            }
        )
        JSON.parse response.body
    rescue => e
      e.response
    end
  end
end
