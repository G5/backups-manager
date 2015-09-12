class OrganizationInvoiceWorker
  include Sidekiq::Worker

  def perform
    Organization.find_each(batch_size: 25) do |o|
      url = "https://api.heroku.com/organizations/#{o.name}/invoices"

      response = HTTPClient.get(url, nil, HerokuApiHelpers.default_headers)
      JSON.parse(response.body).each do |h|
        next if response.code != 200
        invoice_for_organization_and_date(o, h["period_start"]).update_attributes!(
          total: h["total"],
          dyno_units: h["dyno_units"],
          period_end: h["period_end"]
        )
      end
    end
  end

protected

  def invoice_for_organization_and_date(o, period_start)
    scope = o.invoices.where(period_start: period_start)

    if scope.exists?
      scope.first
    else
      o.invoices.build(period_start: period_start)
    end
  end
end
