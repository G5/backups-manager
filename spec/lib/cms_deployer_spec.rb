describe CmsDeployer do
  let(:deployer) { CmsDeployer.new(["app-1", "app-2", "app-3"], "branch-name") }
  let(:heroku_sources_response) { {source_blob: {get_url: "http://get-url.com", put_url: "http://put-url.com"}}.to_json }

  before do
    stub_request(:post, "https://api.heroku.com/apps/app-1/sources").to_return(:status => 200, :body => heroku_sources_response, :headers => {})
    CmsDeployer.any_instance.stub(:download_from_gihub).and_return( true )
    CmsDeployer.any_instance.stub(:upload_to_heroku).and_return( true )
  end

  describe "initializing a deployer" do
    it "sets the branch_name instance variable" do
      expect(deployer.instance_variable_get(:@branch_name)).to eql("branch-name")
    end

    it "sets the github_file_location instance variable" do
      expect(deployer.instance_variable_get(:@github_file_location)).to eql("https://api.github.com/repos/g5search/g5-content-management-system/tarball/branch-name")
    end

    it "sets the heroku_get_url instance variable" do
      expect(deployer.instance_variable_get(:@heroku_get_url)).to eql("http://get-url.com")
    end

    it "sets the heroku_put_url instance variable" do
      expect(deployer.instance_variable_get(:@heroku_put_url)).to eql("http://put-url.com")
    end
  end

  describe "deploy" do
    let(:app_name) { "app-name" }
    let(:source_url) {"http://some-source-url.com"}
    let(:expected_request_body) { {source_blob: {url: source_url} }.to_json }
    let(:heroku_deploy_response) { {id: "abc-123"}.to_json }

    before do
      stub_request(:post, "https://api.heroku.com/apps/#{app_name}/builds").with(:body => expected_request_body ).to_return(:status => 200, :body => heroku_deploy_response, :headers => {})
    end

    it "initiates a build and returns it's id" do
      expect( CmsDeployer.deploy(source_url, app_name) ).to eq("abc-123")
    end
  end

  describe "build_status" do
    let(:app) { "app-name" }
    let(:build_id) { "abc-123" }
    let(:heroku_response_body) { {status: "succeeded"}.to_json }

    before do
      stub_request(:get, "https://api.heroku.com/apps/#{app}/builds/#{build_id}").to_return(:status => 200, :body => heroku_response_body, :headers => {})
    end

    it "returns the build status from the heroku api" do
      expect( CmsDeployer.build_status(app, build_id) ).to eq("succeeded")
    end
  end
end
