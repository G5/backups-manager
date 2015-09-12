describe OrgsController do
  describe 'GET index', auth_controller: true do
    before { allow(RateCheck).to receive(:usage).and_return(2300) }
    let!(:organization) { FactoryGirl.create(:organization) }

    it "correctly assigns stuff" do
      get :index
      expect(assigns(:rate_limit)).to eq(2300)
      expect(assigns(:organizations)).to eq([ organization ])
    end
  end
end
