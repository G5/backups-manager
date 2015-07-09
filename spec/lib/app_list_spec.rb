require 'rails_helper'

describe AppList do
  context "#get_app_list" do
    let(:response_body) { stub_app_details_response }

    before do
      stub_request(:get, "https://la.team%40getg5.com:#{ENV['HEROKU_AUTH_TOKEN']}@api.heroku.com/apps")
        .with(:headers => {'Accept'=>'application/vnd.heroku+json; version=3', 'Accept-Encoding'=>'gzip, deflate', 'Range'=>'name ..; max=1000;', 'User-Agent'=>'Ruby'})
        .to_return(:status => 200, :body => response_body.to_json, :headers => {})
    end

    it "returns the correct data packet" do
      response = AppList.new.get_app_list
      expect(response).to eq(response_body)
    end
  end
end
