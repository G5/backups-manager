describe PerformanceDashboardWorker do
  describe :perform do
    let(:new_relic_response) { fake_new_relic_response }
    let(:pagerduty_oncall_response) { fake_pagerduty_oncall }
    let(:pagerduty_incidents_response) { fake_pagerduty_incidents }
    let(:redis) { Redis.new }
    before do
      new_relic_get_request("https://api.newrelic.com/v2/applications.json")
      pagerduty_get_request("https://ey-g5search.pagerduty.com/api/v1/escalation_policies/on_call", pagerduty_oncall_response)
      pagerduty_get_request("https://ey-g5search.pagerduty.com/api/v1/incidents", pagerduty_incidents_response)
    end
    context "when getting New Relic data" do
      it "sets the appropriate redis keys and values" do
        PerformanceDashboardWorker.perform_async
        parsed_response = JSON.parse new_relic_response.to_json
        expect(JSON.parse(redis.get("1"))[0]).to eq(parsed_response["applications"][0]["name"])
        expect(JSON.parse(redis.get("1"))[1]).to eq(parsed_response["applications"][0]["health_status"])
        expect(JSON.parse(redis.get("1"))[2]).to eq(parsed_response["applications"][0]["application_summary"]["response_time"])
        expect(JSON.parse(redis.get("1"))[3]).to eq(parsed_response["applications"][0]["application_summary"]["apdex_score"])
        expect(JSON.parse(redis.get("1"))[4]).to eq(parsed_response["applications"][0]["application_summary"]["error_rate"])
      end
    end
    context "when getting PagerDuty on call data" do
      it "sets the appropriate redis keys and values" do
        PerformanceDashboardWorker.perform_async
        oncall_parsed_response = JSON.parse fake_pagerduty_oncall.to_json
        expect(JSON.parse(redis.get("P9TX7YH"))[0]).to eq(oncall_parsed_response["on_call"].first["user"]["name"])
        expect(JSON.parse(redis.get("P9TX7YH"))[1]).to eq(oncall_parsed_response["on_call"].first["level"])
        expect(JSON.parse(redis.get("P9TX7YH"))[2]).to eq(oncall_parsed_response["on_call"].first["start"])
        expect(JSON.parse(redis.get("P9TX7YH"))[3]).to eq(oncall_parsed_response["on_call"].first["end"])
      end
    end
    context "when getting PagerDuty incident data" do
      it "sets the appropriate redis keys and values" do
        PerformanceDashboardWorker.perform_async
        incident_parsed_response = JSON.parse pagerduty_incidents_response.to_json
        expect(JSON.parse(redis.get("pagerduty_incident_1"))[0]).to eq(incident_parsed_response["incidents"].first["status"])
        expect(JSON.parse(redis.get("pagerduty_incident_1"))[1]).to eq(incident_parsed_response["incidents"].first["created_on"])
        expect(JSON.parse(redis.get("pagerduty_incident_1"))[2]).to eq(incident_parsed_response["incidents"].first["service"]["name"])
        expect(JSON.parse(redis.get("pagerduty_incident_1"))[3]).to eq(incident_parsed_response["incidents"].first["assigned_to_user"]["name"])
      end
    end
  end
end
