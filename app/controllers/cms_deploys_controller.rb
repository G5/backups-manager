class CmsDeploysController < ApplicationController
  before_filter :authenticate_user!

  def new
  end

  def create
    @cms = params[:cms]
    @branch = params[:branch]

    CmsDeployWorker.perform_async(@cms, @branch)
  end
end
