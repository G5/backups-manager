describe PerformanceDashboardController do
  describe 'POST create' do

    context 'when pagerduty webhook posts incident' do
      let(:redis) { Redis.new }
      before do
        params = JSON.parse(pagerduty_incident_webhook.to_json)
        post :create, params
      end

      it "creates one hash with all incidents" do
        webhook_data = JSON.parse(pagerduty_incident_webhook.to_json)
        incident1 = JSON.parse($redis.get("pagerduty:incidents:1"))
        incident2 = JSON.parse($redis.get("pagerduty:incidents:2"))
        expect(incident1["incident_number"]).to eq(webhook_data["messages"][0]["data"]["incident"]["incident_number"].to_s)
        expect(incident2["incident_number"]).to eq(webhook_data["messages"][1]["data"]["incident"]["incident_number"].to_s)
      end
    end
  end
end
