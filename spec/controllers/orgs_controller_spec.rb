require 'rails_helper'

describe OrgsController do
  describe 'GET index', auth_controller: true do
    let!(:app) { Fabricate(:complete_app) }
    let!(:app2) { Fabricate(:complete_app)}
    let!(:app3) { Fabricate(:complete_app)}
    before do
      stub_request(:get, "https://api.heroku.com/account/rate-limits").
         with(:headers => AppDetails.default_headers).
         to_return(:status => 200, :body => {"remaining" => 2400}.to_json, :headers => {})

        app2.app_details["owner"]["email"] = "group2@herokumanager.com"
        app2.app_details_will_change!
        app2.save

        app3.app_details["owner"]["email"] = "group2@herokumanager.com"
        app3.app_details_will_change!
        app3.save

      get :index
    end

    it "correctly assigns data to @app_list" do
      expect(App.count).to eq(3)
      expect(App.first).to eq(app)
    end

    it { expect(assigns(:data).count).to eq(2) }

    it "groups by app owner" do
      group1_owner = app.app_details["owner"]["email"].gsub("@herokumanager.com", "")

      expect(assigns(:data).first[0]).to eq(group1_owner)
    end
  end
end
