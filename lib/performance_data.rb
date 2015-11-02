class PerformanceData

  def self.get_new_relic_data(uri)
    begin
      response = HTTPClient.
        get("https://api.newrelic.com/v2/applications.json", nil, { "X-Api-Key" => ENV['NEW_RELIC_API_KEY'] }) 
      JSON.parse response.body
    rescue => e
      e.response
    end
  end

  def self.get_pagerduty_oncall(uri)
    begin
      response = HTTPClient.
        get("https://ey-g5search.pagerduty.com/api/v1/escalation_policies/on_call",
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
        get("https://ey-g5search.pagerduty.com/api/v1/incidents",
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
