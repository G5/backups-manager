class CmsDeploysController < ApplicationController
  before_filter :authenticate_user!

  def new
  end

  def create
    @cms = params[:cms]
    @branch = params[:branch]

    cmses = @cms.split(",").map(&:strip)

    blob_url = CmsDeployer.new(cmses, @branch).blob_url

    puts "\n\n\n\n*****\n  Heroku GET URL: #{blob_url} \n*****\n\n\n\n"

    cmses.each do |cms|
      CmsDeployWorker.perform_async(blob_url, cms)
    end
  end
end
