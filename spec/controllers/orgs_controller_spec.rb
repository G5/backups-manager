describe OrgsController do
  let!(:organization) { FactoryGirl.create(:organization) }

  describe 'GET index', auth_controller: true do
    before { allow(RateCheck).to receive(:usage).and_return(2300) }

    it "correctly assigns stuff" do
      get :index
      expect(assigns(:rate_limit)).to eq(2300)
      expect(assigns(:organizations)).to eq([ organization ])
    end
  end

  describe 'GET show', auth_controller: true do
    it "correctly assigns stuff" do
      get :show, id: organization.id
      expect(assigns(:organization)).to eq(organization)
    end
  end
end
