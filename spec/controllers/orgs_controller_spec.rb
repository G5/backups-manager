describe OrgsController do
  describe 'GET index', auth_controller: true do
    let!(:app) { FactoryGirl.create(:app) }
    before { allow(RateCheck).to receive(:usage).and_return(2300) }

    it "correctly assigns data to @app_list" do
      get :index
      expect(assigns(:app_list).count).to eq(1)
      expect(assigns(:app_list).first).to eq(app)
    end
  end
end
