require 'rails_helper'

describe AppList do
  describe "#get" do
    let(:response_body) { stub_app_details_response }

    it "returns the correct data packet" do
      stub_request(:get, "https://api.heroku.com/apps")
        .with(:headers => AppList.default_headers)
        .to_return(:status => 200, :body => response_body.to_json, :headers => {})
      response = AppList.get
      expect(response).to eq(response_body)
    end
  end
end
