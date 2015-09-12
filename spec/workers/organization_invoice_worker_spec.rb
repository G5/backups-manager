describe OrganizationInvoiceWorker do
  describe ".perform" do
    let!(:organization) { FactoryGirl.create(:organization) }
    let(:invoice_hash) do
      [
        {
            "total": 100,
            "dyno_units": 31.486,
            "period_start": "2015-09-01",
            "period_end": "2015-09-14",
            "payment_status": "Pending"
        },
        {
            "total": 200,
            "dyno_units": 71.916,
            "period_start": "2015-08-01",
            "period_end": "2015-09-01",
            "payment_status": "Paid"
        }
      ]
    end

    context "when the organization exists" do
      before do
        stub_request(:get, "https://api.heroku.com/organizations/test-organization/invoices")
          .to_return(status: 200, body: invoice_hash.to_json)
      end

      it "persists historical invoices for each org" do
        OrganizationInvoiceWorker.perform_async
        expect(organization.invoices.count).to eq(2)
        invoices = organization.invoices.order(:period_start)
        expect(invoices[0].total).to eq(200)
        expect(invoices[1].total).to eq(100)
      end

      context "when invoices have updates" do
        before do
          FactoryGirl.create(
            :invoice, organization: organization, total: 300, period_start: "2015-08-01"
          )
        end

        it "updates those invoices" do
          OrganizationInvoiceWorker.perform_async
          expect(organization.invoices.count).to eq(2)
          expect(organization.invoices.order(:period_start).first.total).to eq(200)
        end
      end
    end

    context "when the organization no longer exists" do
      before do
        stub_request(:get, "https://api.heroku.com/organizations/test-organization/invoices")
          .to_return(status: 404, body: { "id" => "not_found" }.to_json)
      end

      it "doesn't explode" do
        expect { OrganizationInvoiceWorker.perform_async }.to_not raise_error
        expect(Invoice.count).to be_zero
      end
    end
  end
end
