describe AppList do
  describe "#get" do
    let(:required_headers) do
      { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
        accept: "application/vnd.heroku+json; version=3",
        range: "name ..; max=1000;" }
    end

    subject { AppList.get }

    it "uses required headers and parses json" do
      stub_request(:get, "https://api.heroku.com/apps")
        .with(headers: required_headers)
        .to_return(status: 200, body: '{"json": "junk"}')

      expect(subject).to eq({"json" => "junk"})
    end

    it "repeats call on 206 response and concats responses" do
      stub_request(:get, "https://api.heroku.com/apps")
        .with(headers: required_headers)
        .to_return(status: 206, body: '[{"thing": "one"}]', headers: {"Next-Range": "some range info"})
      stub_request(:get, "https://api.heroku.com/apps")
        .with(headers: required_headers.merge({range: "some range info"}))
        .to_return(status: 200, body: '[{"thing": "two"}]', headers: {})

      expect(subject).to eq([{"thing" => "one"}, {"thing" => "two"}])
    end
  end

  describe "#sorted" do
    let(:dummy_data) {[ {"name" => "g5-cau-test-one"},
                        {"name" => "g5-cau-test-two"},
                        {"name" => "g5-cls-test-app"},
                        {"name" => "g5-clw-test-test-app"},
                        {"name" => "whatever"} ]}

    let(:expected) { {:cau   => [{"name"=>"g5-cau-test-one"}, {"name"=>"g5-cau-test-two"}],
                      :cls   => [{"name"=>"g5-cls-test-app"}],
                      :clw   => [{"name"=>"g5-clw-test-test-app"}],
                      :cms   => [],
                      :cpas  => [],
                      :cxm   => [],
                      :dsh   => [],
                      :nae   => [],
                      :other => [{"name"=>"whatever"}]} }

    it "uses app name to sort apps according to type" do
      AppList.stub(:get) {dummy_data}
      expect(AppList.sorted).to eq( expected )
    end
  end
end
