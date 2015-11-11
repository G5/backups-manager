describe AppHealthStatusWorker do
  describe :perform do
    let(:unhealthy_app) { unhealthy_app_response }
    let(:healthy_app) { healthy_app_response }
    let(:app) { FactoryGirl.create(:app) } 
    let(:redis) { Redis.new }

    context "when the request hits a healthy app" do
      it "does not set the key and values in redis" do
        g5_ops_health_request("#{app["app_details"]["web_url"]}g5_ops/status.json", healthy_app)
        AppHealthStatusWorker.perform_async
        parsed_response =  JSON.parse healthy_app_response.to_json
        expect(JSON.parse(redis.get("g5ops:health"))[0]).to eq(nil)
      end
    end

    context "when the request hits a unhealthy app" do
      it "sets the key and values in redis"
    end
  end
end
