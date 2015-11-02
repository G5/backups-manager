describe PerformanceData do
  describe "gets New Relic data" do
    let(:new_relic_response) { fake_new_relic_response } 
    let(:pagerduty_oncall)  { fake_pagerduty_oncall  }
    let(:pagerduty_incidents) { fake_pagerduty_incidents  }

    context "#new_relic_data" do
      it "hits the api and parses json" do
        new_relic_get_request("https://api.newrelic.com/v2/applications.json")
        response = PerformanceData.get_new_relic_data("https://api.newrelic.com/v2/applications.json")
        expect(response).to eq(JSON.parse new_relic_response.to_json) 
      end
    end

    context "#get_pagerduty_oncall" do
      it "hits the api and parses json" do
        pagerduty_get_request("https://ey-g5search.pagerduty.com/api/v1/escalation_policies/on_call", pagerduty_oncall)
        response = PerformanceData.get_pagerduty_oncall("https://ey-g5search.pagerduty.com/api/vi/escalation_policies/on_call")
        expect(response).to eq(JSON.parse pagerduty_oncall.to_json)
      end
    end

    context "#get_pagerduty_incidents" do
      it "hits the api and parses json" do
        pagerduty_get_request("https://ey-g5search.pagerduty.com/api/v1/incidents", pagerduty_incidents)
        response = PerformanceData.get_pagerduty_incidents("https://ey-g5search.pagerduty.com/api/v1/incidents")
        expect(response).to eq(JSON.parse pagerduty_incidents.to_json) 
      end
    end
  end
end
