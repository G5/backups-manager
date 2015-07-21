describe AppWranglerWorker do
  describe :perform do
    let(:app_list) { [{"name" => "App"}] }
    before { allow(AppList).to receive(:get).and_return(app_list)}

    context "when an app doesn't exist" do
      it "creates a new app with the correct data" do
        AppWranglerWorker.perform_async
        expect(App.first.app_details["name"]).to eq(app_list[0]["name"])
      end
    end

    context "when an app already exists in the database" do
      it "updates the existing app without creating a new one" do
        App.create(id: 1, name: "App")
        AppWranglerWorker.perform_async
        expect(App.count).to eq(1)
      end
    end
  end
end
