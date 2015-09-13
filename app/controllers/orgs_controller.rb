class OrgsController < ApplicationController
  def index
    @organizations = eager_organization_scope.order(:email).all
    @rate_limit = RateCheck.usage
  end

  def show
    @organization = eager_organization_scope.find(params[:id])
  end

protected

  def eager_organization_scope
    Organization.includes(:apps).includes(:invoices)
  end
end
