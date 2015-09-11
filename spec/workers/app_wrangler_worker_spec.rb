describe AppWranglerWorker do
  describe :perform do
    let(:app_list) do
      [
        {
          "name" => "App",
          "owner" => { "email" => "org-name@herokumanager.com", "id" => "org-guid" }
        }
      ]
    end
    before { allow(AppList).to receive(:get).and_return(app_list)}

    context "when no organization exists" do
      it "creates a new organization" do
        AppWranglerWorker.perform_async
        expect(Organization.count).to eq(1)
        o = Organization.first
        expect(o.email).to eq("org-name@herokumanager.com")
        expect(o.guid).to eq("org-guid")
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

        it "updates the existing app without creating a new one" do
          AppWranglerWorker.perform_async
          expect(App.count).to eq(1)
          expect(App.first.organization).to eq(Organization.first)
        end
      end
    end

    context "when the organization already exists" do
      let!(:organization) { FactoryGirl.create(:organization, guid: "org-guid") }

      it "associates the app with the existing organization" do
        AppWranglerWorker.perform_async
        expect(Organization.count).to eq(1)
        expect(App.first.organization).to eq(organization)
      end
    end
  end
end
