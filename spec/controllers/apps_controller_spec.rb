describe AppsController do
  let!(:app) { FactoryGirl.create(:app) }
  before { allow(RateCheck).to receive(:usage).and_return(2300) }

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
      let!(:app) { FactoryGirl.create(:clw_app) }

      it "assigns the domains instance var" do
        get :show, id: app.id
        expect(assigns(:domains)).to eq(app.domains)
      end
    end
  end
end
