require 'rails_helper'

describe AppsController do
  describe 'GET index', auth_controller: true do
    let!(:app) { Fabricate(:complete_app) }
    before do
      stub_request(:get, "https://api.heroku.com/account/rate-limits").
         with(:headers => AppDetails.new(app.app_details["name"]).header).
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

  describe 'GET show', auth_controller: true do
    context "when showing a non clw app" do
      let!(:app) { Fabricate(:complete_app) }
      before do
        stub_request(:get, "https://api.heroku.com/account/rate-limits").
           with(:headers => AppDetails.new(app.app_details["name"]).header).
           to_return(:status => 200, :body => {"remaining" => 2400}.to_json, :headers => {})

        get :show, id: app.id
      end

      it { expect(assigns(:app)).to eq(app) }
      it { expect(assigns(:app_name)).to eq(app.name) }
      it { expect(assigns(:app_url)).to eq(app.app_details["web_url"]) }
      it { expect(assigns(:app_git_url)).to eq(app.app_details["git_url"]) }
      it { expect(assigns(:updated_at)).to eq(app.app_details["updated_at"]) }
      it { expect(assigns(:addons)).to eq(app.addons) }
      it { expect(assigns(:config_vars)).to eq(app.config_variables) }
      it { expect(assigns(:dynos)).to eq(app.dynos) }
    end
    

    context "setting app domains for clw apps only" do
      let!(:clw_app) { Fabricate(:complete_app, name: "g5-clw-1sjhz1kl-holland-reside") }
      before do
        stub_request(:get, "https://api.heroku.com/account/rate-limits").
           with(:headers => AppDetails.new(clw_app.app_details["name"]).header).
           to_return(:status => 200, :body => {"remaining" => 2400}.to_json, :headers => {})

        get :show, id: clw_app.id
      end

      it { expect(assigns(:domains)).to eq(clw_app.domains) }
    end
  end
end
