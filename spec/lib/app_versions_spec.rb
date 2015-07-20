require 'rails_helper'

describe AppVersions do
  before(:each) do
    allow(AppVersions).to receive(:app_list)
      .and_return({ 'cau' => "G5/g5-sibling-deployer",
                    'cls' => "g5search/g5-client-leads-service",
                    'cms' => "g5search/g5-content-management-system",
                    'dsh' => "g5search/g5-dashboard" })
  end

  describe ".master_versions" do
    before do
      expect(AppVersions).to receive(:fetch_master_version).and_return("0.5.0")
        .exactly(4).times
    end
    
    it "collects the versions for each app type" do
      #repeat to confirm fetch calls are cached
      2.times do
        expect(AppVersions.master_versions).to eq({'cau' => "0.5.0",'cls' => "0.5.0",'cms' => "0.5.0",'dsh' => "0.5.0"})
      end
    end
  end

  describe ".master_version_inputs" do
    before do
      allow(AppVersions).to receive(:master_versions)
        .and_return({'cau' => "1.5.0",'cls' => "0.5.0",'cms' => "2.0.0",'dsh' => "2.5.0"})
    end

    it "creates hidden html inputs with the app types and versions" do
      expected = "<input type='hidden' id='master-version-cau' value='1.5.0'>" +
                 "<input type='hidden' id='master-version-cls' value='0.5.0'>" +
                 "<input type='hidden' id='master-version-cms' value='2.0.0'>" +
                 "<input type='hidden' id='master-version-dsh' value='2.5.0'>"

      expect(AppVersions.master_version_inputs).to eq(expected)
    end
  end

  describe ".fetch_master_version" do
    subject {AppVersions.send(:fetch_master_version, "dsh")}
    let(:endpoint) {"https://api.github.com/repos/g5search/g5-dashboard/contents/config/version.yml?access_token=#{ENV['GITHUB_ACCESS_TOKEN']}"}

    context "successful request (200)" do
      let(:json) { '{"content": "dmVyc2lvbjogJzIuMC4zJwpuYW1lOiAnRzUgQ29udGVudCBNYW5hZ2VtZW50\nIFN5c3RlbScK\n"}'}
      before { stub_request(:get, endpoint).to_return(:status => 200, :body => json) }

      it "returns a version string on http 200" do
        expect(subject).to eq("2.0.3")
      end
    end

    context "failed request (non-200)" do
      before { stub_request(:get, endpoint).to_return(:status => 500, :body => "") }

      it "returns nil" do
        expect(subject).to eq(nil)
      end
    end
  end
end
