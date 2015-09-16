describe AppTypesController do
  let!(:app) { FactoryGirl.create(:app, name: "g5-clw-testing") }
  before { allow(RateCheck).to receive(:usage).and_return(2300) }

  describe 'GET index', auth_controller: true do
    it "correctly assigns data to @app_types" do
      get :index
      expect(assigns(:app_types).count).to eq(2)
      expect(assigns(:app_types)["clw"]).to eq([ app ])
    end
  end

  describe "GET show", auth_controller: true do
    context "getting an existing type" do

      it "assigns stuff" do
        get :show, id: "clw"
        expect(assigns(:type)).to eq("clw")
        expect(assigns(:apps)).to eq([ app ])
      end
    end

    context "getting a non-existant type" do
      it "returns a RecordNotFound exception" do
        expect { get :show, id: "your-mom" }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
