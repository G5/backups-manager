describe PerformanceData do
  describe "gets New Relic data" do
    let(:required_headers) do
      { authorization: "Bearer #{ENV['NEW_RELIC_API_KEY']}" }
    end
    
    let(:response_body) do
      {
        "applications": [
          {
            "id": 1,
            "name": "Test App",
            "language": "ruby",
            "health_status": "green",
            "reporting": true,
            "last_reported_at": "2015-10-28T22:48:42+00:00",
            "application_summary": {
              "response_time": 435,
              "throughput": 1620,
              "error_rate": 0,
              "apdex_target": 0.5,
              "apdex_score": 0.86,
              "host_count": 8,
              "instance_count": 44
            },
            "end_user_summary": {
              "response_time": 3.64,
              "throughput": 287,
              "apdex_target": 4,
              "apdex_score": 0.85
            },
            "settings": {
              "app_apdex_threshold": 0.5,
              "end_user_apdex_threshold": 4,
              "enable_real_user_monitoring": true,
              "use_server_side_config": true
            }
          }]}
    end

    context "#new_relic_data" do
      it "hits the api and parses json" do
        stub_request(:get, "https://api.newrelic.com/v2/applications.json").
                   with(:headers => { 'X-Api-Key'=>ENV['NEW_RELIC_API_KEY']}).
                   to_return(:status => 200, :body => response_body.to_json)
        response = PerformanceData.get_new_relic_data("https://api.newrelic.com/v2/applications.json")
        expect(response).to eq(JSON.parse response_body.to_json) 
      end
    end

    context "#pagerduty_data" do
      it "hits the api and parses json"
    end
  end
end
