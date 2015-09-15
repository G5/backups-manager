describe LiveSummariesController do
  describe 'GET index', auth_controller: true do
    let(:app) { FactoryGirl.create(:app, name: "appster") }

    before do
      stub_request(:get, "https://api.heroku.com/apps/appster/formation")
        .to_return(status: 200, body: '[{"type": "1X"}]')

      get :index, app_id: app.id
    end

    it "provides the app to the view" do
      expect(assigns(:app)).to eq(app)
    end

    it "makes a request for the app dynos and provides them to the view" do
      expect(assigns(:app_dynos)).to eq([{"type" => "1X"}])
    end
  end
end
