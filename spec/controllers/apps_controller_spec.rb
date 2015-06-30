require 'rails_helper'

describe AppsController do
  describe 'GET index', auth_controller: true do
    let!(:app) { Fabricate(:complete_app) }
    before do
      stub_request(:get, "https://la.team%40getg5.com:#{ENV['HEROKU_AUTH_TOKEN']}@api.heroku.com/account/rate-limits").
         with(:headers => {'Accept'=>'application/vnd.heroku+json; version=3', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => {"remaining" => 2400}.to_json, :headers => {})

      get :index
    end 

    it "correctly assigns data to @app_list" do
      expect(App.count).to eq(1)
      expect(App.first).to eq(app)
    end

    it "assigns the correct @app_count" do
      expect(assigns(:app_count)).to eq(App.count)
    end
  end

end
