class OrgsController < ApplicationController
  def index
    @organizations = Organization.
      order(:email).
      includes(:apps).
      includes(:invoices).
      all
    @rate_limit = RateCheck.usage
  end
end
