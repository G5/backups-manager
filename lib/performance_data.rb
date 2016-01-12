class PerformanceData
  def self.new_relic_data
    data = get_new_relic_data("https://api.newrelic.com/v2/applications.json")
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
    data = get_pagerduty_oncall("https://ey-g5search.pagerduty.com/api/v1/escalation_policies/on_call")
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

  def self.create_pagerduty_incident(params)
    params["messages"].each do |incident|
      incident_info = incident["data"]["incident"]
      incident_data = {
          incident_number: incident_info["incident_number"],
          status: incident_info["status"],
          created_at: incident["created_on"],
          description: incident_info["trigger_summary_data"]["subject"]
        }
      $redis.setex("pagerduty:incidents:#{incident_info["incident_number"]}", 3600, incident_data.to_json)
    end
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
end
