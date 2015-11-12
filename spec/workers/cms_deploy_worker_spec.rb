describe CmsDeployWorker do
  describe :perform do

    let(:app_name) { "app-name" }
    let(:source_url) {"http://some-source-url.com"}
    let(:expected_request_body) { {source_blob: {url: source_url} }.to_json }
    let(:heroku_deploy_response) { {id: "abc-123"}.to_json }

    before do
      stub_request(:post, "https://api.heroku.com/apps/#{app_name}/builds").with(:body => expected_request_body ).to_return(:status => 200, :body => heroku_deploy_response, :headers => {})
      stub_request(:get, "https://api.heroku.com/apps/#{app_name}/builds/abc-123").to_return(:status => 200, :body => "{}", :headers => {})
      DeployNotification.stub(:new)
    end

    describe "basic deploys" do
      let(:deploy_params) { { app: app_name,
                              blob_url: source_url,
                              capture_backup: false,
                              run_migrations: false } }

      it "kicks off a deploy of the app" do
        expect(CmsDeployer).to receive(:deploy).with(deploy_params[:blob_url], deploy_params[:app])
        CmsDeployWorker.perform_async( deploy_params )
      end
    end

    describe "deploys with backup" do
      let(:deploy_params) { { app: app_name,
                              blob_url: source_url,
                              capture_backup: true,
                              run_migrations: false } }

      before do
        CmsPostDeployWorker.stub(:perform_async)
      end

      it "calls for a pg:backup" do
        expect(CmsDeployer).to receive(:capture_backup).with(deploy_params[:app])
        CmsDeployWorker.perform_async( deploy_params )
      end
    end

    describe "post deploy tasks" do
      let(:deploy_params) { { "app" => app_name,
                              "blob_url" => source_url,
                              "capture_backup" => false,
                              "run_migrations" => true } }

      it "queues up post deploy tasks" do
        expect(CmsPostDeployWorker).to receive(:perform_async).with(deploy_params, "abc-123")
        CmsDeployWorker.perform_async( deploy_params )
      end
    end
  end
end


