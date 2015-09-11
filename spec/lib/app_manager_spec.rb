describe AppManager do 
  let(:test_app) { AppManager.new("some-app-name") }

  let(:success_response) { response = Struct.new(:code)
                           response.new(200) }

  let(:failure_response) { response = Struct.new(:code)
                           response.new(422) }

  let(:test_uri) { "https://api.heroku.com/apps/some-app-name" }

  let(:default_headers) { { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}", 
                            accept: "application/vnd.heroku+json; version=3"} }

  let(:json_headers) { { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}", 
                         accept: "application/vnd.heroku+json; version=3", 
                         content_type: 'application/json'} }

  describe "#delete" do
    it "correctly calls the delete method on the heroku api via RestClient" do
      allow(RestClient).to receive(:delete).and_return(failure_response)
      allow(RestClient).to receive(:delete).
        with(test_uri, default_headers).
        and_return(success_response)
      expect(test_app.delete).to eq(true)
    end
  end

  describe "#spin_down" do
    let(:test_data) { {updates:[{process:"web", quantity: 0, size: "1X"},{process:"worker", quantity: 0, size: "1X"}]}.to_json }

    it "correctly calls the formation method on the heroku api via RestClient" do
      allow(RestClient).to receive(:patch).and_return(failure_response)
      allow(RestClient).to receive(:patch).
        with("#{test_uri}/formation", test_data, json_headers).
        and_return(success_response)
      expect(test_app.spin_down).to eq(true)
    end
  end

  describe "#set_config_variable" do
    it "correctly calls the config-vars method on the heroku api via RestClient" do
      allow(RestClient).to receive(:patch).and_return(failure_response)
      allow(RestClient).to receive(:patch).
        with("#{test_uri}/config-vars", {"GIGITY": "goo"}.to_json, json_headers).
        and_return(success_response)
      expect(test_app.set_config_variable("GIGITY", "goo")).to eq(true)
    end
  end 
end
