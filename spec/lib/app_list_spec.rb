require 'rails_helper'

describe AppList do
  context "#get_app_list" do
    let(:response_body) do
      [
        {
          "archived_at" => nil,
          "buildpack_provided_description" => "Ruby",
          "build_stack" => {
            "id" => "7e04461d-ec81-4bdd-8b37-b69b320a9f83",
            "name" => "cedar"
          },
          "created_at" => "2014-09-11T16:45:47Z",
          "id" => "21b5bfc9-b470-4270-98a7-ae1e525eaca4",
          "git_url" => "git@heroku.com:g5-cls-1sjhz1kl-holland-reside.git",
          "maintenance" => false,
          "name" => "g5-cls-1sjhz1kl-holland-reside",
          "owner" => {
            "email" => "holland-residential@herokumanager.com",
            "id" => "c8aa0090-33a6-4b7d-b41d-c16d9d46c704"
          },
          "region" => {
            "id" => "59accabd-516d-4f0e-83e6-6e3757701145",
            "name" => "us"
          },
          "released_at" => "2015-06-15T15:28:58Z",
          "repo_size" => 2606796,
          "slug_size" => 40887434,
          "stack" => {
            "id" => "7e04461d-ec81-4bdd-8b37-b69b320a9f83",
            "name" => "cedar"
          },
          "updated_at" => "2015-06-17T20:39:23Z",
          "web_url" => "https://g5-cls-1sjhz1kl-holland-reside.herokuapp.com/"
        },
      ]
    end

    before do
      stub_request(:get, "https://la.team%40getg5.com:#{ENV['HEROKU_AUTH_TOKEN']}@api.heroku.com/apps").with(:headers => {'Accept'=>'application/vnd.heroku+json; version=3', 'Accept-Encoding'=>'gzip, deflate', 'Range'=>'name ..; max=1000;', 'User-Agent'=>'Ruby'}).to_return(:status => 200, :body => response_body.to_json, :headers => {})
    end

    it "returns the correct data packet" do
      response = AppList.new.get_app_list
      expect(response).to eq(response_body)
    end
  end
end
