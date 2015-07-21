describe AppDetails do
  let(:app_name) { "App"}
  let(:json) { {"json" => "any"} }

  describe "#get_app_dynos" do
    it "hits the api and parses json" do
      stub_request(:get, "https://api.heroku.com/apps/#{app_name}/formation")
        .with(:headers => AppDetails.default_headers)
        .to_return(:status => 200, :body => json.to_json)

      app_dynos = AppDetails.new(app_name).get_app_dynos
      expect(app_dynos).to eq(json)
    end
  end

  describe "#get_app_addons" do
    it "hits the api and parses json" do
      stub_request(:get, "https://api.heroku.com/apps/#{app_name}/addons")
        .with(:headers => AppDetails.default_headers)
        .to_return(:status => 200, :body => json.to_json)

      app_addons = AppDetails.new(app_name).get_app_addons
      expect(app_addons).to eq(json)
    end
  end

  describe "#get_app_config_variables" do
    it "hits the api and parses json" do
      stub_request(:get, "https://api.heroku.com/apps/#{app_name}/config-vars")
        .with(:headers => AppDetails.default_headers)
        .to_return(:status => 200, :body => json.to_json)

      app_config_vars = AppDetails.new(app_name).get_app_config_variables
      expect(app_config_vars).to eq(json)
    end
  end

  describe "#get_app_domains" do
    it "hits the api and parses json" do
      stub_request(:get, "https://api.heroku.com/apps/#{app_name}/domains")
        .with(:headers => AppDetails.default_headers)
        .to_return(:status => 200, :body => json.to_json)

      app_domains = AppDetails.new(app_name).get_app_domains
      expect(app_domains).to eq(json)
    end
  end

  describe "#delete" do
    pending
  end

  describe "#spin_down" do
    pending
  end
end
