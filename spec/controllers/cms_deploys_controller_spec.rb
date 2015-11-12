describe CmsDeploysController, auth_controller: true do

  describe "deploy configuration" do
    let(:basic_deploy_params) { { cms: "g5-cms-123abc-clown", 
                                  branch: "master" } }

    let(:full_deploy_params)  { { cms: "g5-cms-123abc-clown", 
                                  branch: "master",
                                  capture_pg_backup: "1",
                                  run_migrations: "1" } }

    let(:time_now) { Time.parse("1997-08-29 02:14:00 -0500") }

    before { 
      CmsDeployer.stub_chain(:new, :blob_url) {"http://blob-yo.com"} 
      allow(Time).to receive(:now).and_return(time_now)
    }

    it "Queues up a CmsDeployWorker with the correct args for basic deploys" do
      expected_args = { app: "g5-cms-123abc-clown",
                        blob_url: "http://blob-yo.com",
                        capture_backup: false,
                        run_migrations: false,
                        pusher_channel: "cms-deploy-#{time_now.to_i}" }
  
      expect(CmsDeployWorker).to receive(:perform_async).with(expected_args)
      post :create, basic_deploy_params
    end

    it "Queues up a CmsDeployWorker with the correct args for full deploys" do
      expected_args = { app: "g5-cms-123abc-clown",
                        blob_url: "http://blob-yo.com",
                        capture_backup: true,
                        run_migrations: true,
                        pusher_channel: "cms-deploy-#{time_now.to_i}" }
  
      expect(CmsDeployWorker).to receive(:perform_async).with(expected_args)
      post :create, full_deploy_params
    end
  end

  describe "deploying multiple CMSs" do
    let(:deploy_params) { { cms: "g5-cms-123abc-clown, g5-cms-987xyz-monkey, g5-cms-666dps-joker", 
                            branch: "master" } }

    let(:cms_deployer) { OpenStruct.new(blob_url: "http://blob-yo.com") }

    let(:arg1) { ["g5-cms-123abc-clown", "g5-cms-987xyz-monkey", "g5-cms-666dps-joker"] }
    let(:arg2) { "master" }

    it "creates a new CmsDeployer" do
      CmsDeployWorker.stub(:perform_async)
      expect(CmsDeployer).to receive(:new).with(arg1, arg2).and_return(cms_deployer)
      post :create, deploy_params
    end

    it "Queues up a CmsDeployWorker for each CMS" do
      CmsDeployer.stub(:new).with(arg1, arg2).and_return(cms_deployer)
      expect(CmsDeployWorker).to receive(:perform_async).exactly(3).times.and_return(true)
      post :create, deploy_params
    end
  end
end
