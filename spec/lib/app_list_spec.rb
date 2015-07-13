require 'rails_helper'

describe AppList do
  describe "#get_app_list" do
    let(:response_body) { stub_app_details_response }

    it "returns the correct data packet" do
      stub_request(:get, "https://api.heroku.com/apps")
        .with(:headers => AppList.new.create_headers)
        .to_return(:status => 200, :body => response_body.to_json, :headers => {})
      response = AppList.new.get_app_list
      expect(response).to eq(response_body)
    end
  end
end
