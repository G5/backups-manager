describe CmsDeploysController, auth_controller: true do

  before do
    # CmsDeployer.stub_chain(:new, :blob_url).and_return("http://blob-yo.com")
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

  # describe "deploy configuration" do
  #   let(:basic_deploy_params) { { cms: "g5-cms-123abc-clown", 
  #                                 branch: "master" } }

  #   let(:full_deploy_params)  { { cms: "g5-cms-123abc-clown", 
  #                                 branch: "master",
  #                                 capture_pg_backup: "1",
  #                                 run_migrations: "1" } }
  # end
end