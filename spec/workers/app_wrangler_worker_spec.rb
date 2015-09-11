describe AppWranglerWorker do
  describe :perform do
    let(:app_list) do
      [
        {
          "name" => "App",
          "owner" => { "email" => "test-organization@herokumanager.com", "id" => "12345-ABCDE" }
        }
      ]
    end
    before { allow(AppList).to receive(:get).and_return(app_list)}

    context "when the organization exists" do
      it "creates a new organization" do
        AppWranglerWorker.perform_async
        expect(Organization.count).to eq(1)
        o = Organization.first
        expect(o.email).to eq("test-organization@herokumanager.com")
        expect(o.guid).to eq("12345-ABCDE")
      end

      context "when an app doesn't exist" do
        it "creates a new app with the correct data" do
          AppWranglerWorker.perform_async
          expect(App.first.app_details["name"]).to eq(app_list[0]["name"])
          expect(App.first.organization).to eq(Organization.first)
        end
      end

      context "when an app already exists in the database" do
        before { FactoryGirl.create(:app, name: "App") }

        it "does not create a duplicate app" do
          AppWranglerWorker.perform_async
          expect(App.count).to eq(1)
          expect(Organization.count).to eq(1)
        end
      end
    end

    context "when the organization already exists" do
      let!(:organization) { FactoryGirl.create(:organization, guid: "12345-ABCDE") }

      it "associates the app with the existing organization" do
        AppWranglerWorker.perform_async
        expect(Organization.count).to eq(1)
        expect(App.first.organization).to eq(organization)
      end

      context "when the app moves organizations" do
        let(:old_organization) { FactoryGirl.create(:organization) }
        let!(:app) { FactoryGirl.create(:app, name: "App", organization: old_organization) }

        it "reassociates the app with its new organization" do
          AppWranglerWorker.perform_async
          expect(app.reload.organization).to eq(organization)
        end
      end
    end
  end
end
