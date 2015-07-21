require 'rails_helper'

describe AppsController do
  let!(:app) do
    App.create(
      id: 1, name: "App",
      app_details: {"web_url" => "_", "git_url" => "_", "updated_at" => "_"},
      addons: {}, config_variables: {}, dynos: {}, domains: {} )
  end

  before { allow(RateCheck).to receive(:usage).and_return(2300) }

  describe 'GET index', auth_controller: true do
    it "correctly assigns data to @app_list" do
      get :index
      expect(assigns(:app_list).count).to eq(1)
      expect(assigns(:app_list).first).to eq(app)
    end
  end

  describe 'GET show', auth_controller: true do
    context "when showing a non clw app" do
      it "correctly assigns instance vars" do
        get :show, id: app.id
        expect(assigns(:app)).to eq(app)
        expect(assigns(:app_name)).to eq(app.name)
        expect(assigns(:app_url)).to eq(app.app_details["web_url"])
        expect(assigns(:app_git_url)).to eq(app.app_details["git_url"])
        expect(assigns(:updated_at)).to eq(app.app_details["updated_at"])
        expect(assigns(:addons)).to eq(app.addons)
        expect(assigns(:config_vars)).to eq(app.config_variables)
        expect(assigns(:dynos)).to eq(app.dynos)
        expect(assigns(:domains)).to eq(nil)
      end
    end

    context "when showing a clw app" do
      it "assigns the domains instance var" do
        app.update_attributes(name: "g5-clw-1sjhz1kl-holland-reside")
        get :show, id: app.id
        expect(assigns(:domains)).to eq(app.domains)
      end
    end
  end
end
