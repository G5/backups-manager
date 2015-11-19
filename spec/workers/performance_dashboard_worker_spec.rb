describe PerformanceDashboardWorker do
  describe :perform do
    let(:new_relic_response) { fake_new_relic_response }
    let(:pagerduty_oncall_response) { fake_pagerduty_oncall }
    let(:pagerduty_incidents_response) { fake_pagerduty_incidents }
    let(:redis) { Redis.new }

    before do
      new_relic_get_request("https://api.newrelic.com/v2/applications.json")
      pagerduty_get_request("https://ey-g5search.pagerduty.com/api/v1/escalation_policies/on_call", pagerduty_oncall_response)
      pagerduty_get_request("https://ey-g5search.pagerduty.com/api/v1/incidents?status=triggered,acknowledged", pagerduty_incidents_response)
    end
    context "when getting New Relic data" do
      it "sets the appropriate redis keys and values" do
        PerformanceDashboardWorker.perform_async
        parsed_response = JSON.parse new_relic_response.to_json
        expect(JSON.parse($redis.get("newrelic:data"))[0]["name"]).to eq(parsed_response["applications"][0]["name"])
        expect(JSON.parse($redis.get("newrelic:data"))[0]["health_status"]).to eq(parsed_response["applications"][0]["health_status"])
        expect(JSON.parse($redis.get("newrelic:data"))[0]["response_time"]).to eq(parsed_response["applications"][0]["application_summary"]["response_time"])
        expect(JSON.parse($redis.get("newrelic:data"))[0]["apdex_score"]).to eq(parsed_response["applications"][0]["application_summary"]["apdex_score"])
        expect(JSON.parse($redis.get("newrelic:data"))[0]["error_rate"]).to eq(parsed_response["applications"][0]["application_summary"]["error_rate"])
      end

      it "does not set redis for an app that is not reporting" do
        PerformanceDashboardWorker.perform_async
        JSON.parse($redis.get("newrelic:data"))[1].should be_nil
      end
    end
    context "when getting PagerDuty on call data" do
      it "sets the appropriate redis keys and values" do
        PerformanceDashboardWorker.perform_async
        oncall_parsed_response = JSON.parse pagerduty_oncall_response.to_json
        expect(JSON.parse($redis.get("pagerduty:oncall"))[0]["user"]).to eq(oncall_parsed_response["escalation_policies"][0]["on_call"].first["user"]["name"])
        expect(JSON.parse($redis.get("pagerduty:oncall"))[0]["level"]).to eq(oncall_parsed_response["escalation_policies"][0]["on_call"].first["level"])
        expect(JSON.parse($redis.get("pagerduty:oncall"))[0]["start_date_time"]).to eq(oncall_parsed_response["escalation_policies"][0]["on_call"].first["start"])
        expect(JSON.parse($redis.get("pagerduty:oncall"))[0]["end_date_time"]).to eq(oncall_parsed_response["escalation_policies"][0]["on_call"].first["end"])
      end
    end
    context "when getting PagerDuty incident data" do
      it "sets the appropriate redis keys and values" do
        PerformanceDashboardWorker.perform_async
        incident_parsed_response = JSON.parse pagerduty_incidents_response.to_json
        expect(JSON.parse($redis.get("pagerduty:incidents"))[0]["status"]).to eq(incident_parsed_response["incidents"].first["status"])
        expect(JSON.parse($redis.get("pagerduty:incidents"))[0]["created_at"]).to eq(incident_parsed_response["incidents"].first["created_on"])
        expect(JSON.parse($redis.get("pagerduty:incidents"))[0]["description"]).to eq(incident_parsed_response["incidents"].first["trigger_summary_data"]["description"])
      end
    end
  end
end
