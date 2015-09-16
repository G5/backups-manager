describe CashController, auth_controller: true do
  let!(:app) { FactoryGirl.create(:app) }
  let!(:sql_app) { FactoryGirl.create(:paid_db_app) }

  describe "GET index" do
    it "assigns an array of known database plans" do
      get :index
      expect(assigns(:database_plans)).to match_array([ "hobby-dev", "hobby-basic" ])
    end

    it "assigns no apps" do
      get :index
      expect(assigns(:apps)).to be_nil
    end

    describe "filtering by database_plan_id" do
      it "assigns apps filtered by database plan" do
        get :index, database_plan_id: "hobby-dev"
        expect(assigns(:apps)).to eq([ sql_app ])
      end
    end
  end
end
