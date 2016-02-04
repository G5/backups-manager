class Organization < ActiveRecord::Base
  has_many :apps
  has_many :invoices

  validates :email, :guid, presence: true

  def get_name
    email.match(/(.+)@/)[1]
  end

  def projected_monthly_cost
    return "?" if invoices.empty?

    current_invoice = invoices.first
    latest_invoice_date = current_invoice.period_end
    month_elapsed = latest_invoice_date.day / latest_invoice_date.end_of_month.day.to_f
    projected = (current_invoice.total / 100) / month_elapsed
    "$#{projected.round}"
  end

  def self.sort_cost_descending(organizations)
    totals_hash = {}
    organizations.each do |org|
      cost = org.projected_monthly_cost.gsub(/\$?/, "").to_i
      totals_hash[org.name] = cost
    end
    desc_totals = totals_hash.sort_by {|k, v| v}.reverse
  end
end
