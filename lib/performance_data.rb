class PerformanceData
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
