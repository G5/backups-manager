describe PerformanceDashboardWorker do
  describe :perform do
    context "when getting New Relic data" do
      let(:new_relic_response) { fake_new_relic_response }
      let(:redis) { Redis.new }
      it "sets the appropriate redis keys and values" do
        new_relic_get_request("https://api.newrelic.com/v2/applications.json")
        PerformanceDashboardWorker.perform_async
        parsed_response = JSON.parse new_relic_response.to_json
        expect(JSON.parse(redis.get("1"))[0]).to eq(parsed_response["applications"][0]["name"])
      end
    end
    context "when getting PagerDuty on call data"
    context "when getting PagerDuty incident data"
  end
end
