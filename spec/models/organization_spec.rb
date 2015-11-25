describe Organization do
  describe "#name" do
    it "strips out the email addressy bits" do
      app = Organization.new(email: "test@herokumanager.com")
      expect(app.name).to eq("test")
    end
  end

  describe "#projected_monthly_cost" do
    let(:organization) { FactoryGirl.create(:organization) }
    subject { organization.projected_monthly_cost }

    context "for an organization with no invoices" do
      it { should eq("?") }
    end

    context "for an organization with an invoice" do
      before do
        FactoryGirl.create(
          :invoice,
          organization: organization,
          total: 1000,
          period_start: "2015-09-01",
          period_end: "2015-09-22"
        )
      end

      it { should eq("$14") }
    end
  end

  describe "#sort_cost_descending" do
    let(:organization) { FactoryGirl.create(:organization) }
    let(:organization2) { FactoryGirl.create(:organization) }

    context "when sorting orgs by monthly projection" do
      before do
        FactoryGirl.create(
          :invoice,
          organization: organization,
          total: 1000,
          period_start: "2015-09-01",
          period_end: "2015-09-22"
        )

        FactoryGirl.create(
          :invoice,
          organization: organization2,
          total: 2000,
          period_start: "2015-09-01",
          period_end: "2015-09-22"
        )
      end
      it "orders the orgs from highest to lowest cost" do
        desc_orgs = Organization.sort_cost_descending(Organization.all)
        expect(desc_orgs.first).to eq([organization2.name, organization2.projected_monthly_cost.gsub(/\$?/, "").to_i])
      end
    end
  end
end
