describe PerformanceData do
  describe "gets app performance data" do
    before do
      new_relic_get_request("https://api.newrelic.com/v2/applications.json")
      pagerduty_get_request("https://ey-g5search.pagerduty.com/api/v1/escalation_policies/on_call", fake_pagerduty_oncall)
    end

    context "#new_relic_data" do
      it "hits the api and parses json" do
        response = PerformanceData.get_new_relic_data("https://api.newrelic.com/v2/applications.json")
        expect(response).to eq(JSON.parse fake_new_relic_response.to_json)
      end
    end

    context "#get_pagerduty_oncall" do
      it "hits the api and parses json" do
        response = PerformanceData.get_pagerduty_oncall("https://ey-g5search.pagerduty.com/api/v1/escalation_policies/on_call")
        expect(response).to eq(JSON.parse fake_pagerduty_oncall.to_json)
      end
    end
  end

  describe "Real-time Pagerduty incidents" do
    context "gets current incidents" do
      it "renders current incidents starting with most recent"
    end
  end
end
