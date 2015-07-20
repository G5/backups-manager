require 'rails_helper'

describe OrgsController do
  describe 'GET index', auth_controller: true do
    let!(:app)  { App.create(id: 1, name: "App 1", app_details: { "owner" => {"email" => "group2@herokumanager.com"} }) }

    before do
      allow(RateCheck).to receive(:usage).and_return(2300)
      get :index
    end

    it "correctly assigns data to @app_list" do
      expect(assigns(:app_list).count).to eq(1)
      expect(assigns(:app_list).first).to eq(app)
    end

    it { expect(assigns(:grouped_apps).count).to eq(1) }

    it "groups by app owner" do
      group1_owner = app.app_details["owner"]["email"].gsub("@herokumanager.com", "")

      expect(assigns(:grouped_apps).first[0]).to eq(group1_owner)
    end
  end
end
