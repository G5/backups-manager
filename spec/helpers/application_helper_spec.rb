require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#projected_monthly_cost" do
    let(:organization) { FactoryGirl.create(:organization) }
    subject { helper.projected_monthly_cost(organization) }

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
end
