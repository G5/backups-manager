class CmsDeploysController < ApplicationController
  before_filter :authenticate_user!

  def new
  end

  def create
    @cms = params[:cms]
    @branch = params[:branch]

    cmses = @cms.split(",").map(&:strip)

    cmses.each do |cms|
      CmsDeployWorker.perform_async(cms, @branch)
    end
  end
end
