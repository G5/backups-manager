describe OrgsController do
  describe 'GET index', auth_controller: true do
    let!(:app)  { App.create(id: 1, name: "App 1", app_details: { "owner" => {"email" => "group2@herokumanager.com"} }) }
    before { allow(RateCheck).to receive(:usage).and_return(2300) }

    it "correctly assigns data to @app_list" do
      get :index
      expect(assigns(:app_list).count).to eq(1)
      expect(assigns(:app_list).first).to eq(app)
    end
  end
end
