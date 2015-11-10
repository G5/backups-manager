class CmsDeploysController < ApplicationController
  before_filter :authenticate_user!

  def new
  end

  def create
    @cms = params[:cms]
    @branch = params[:branch]
    @cmses = @cms.split(",").map(&:strip)
    @capture_backup = params.key?(:capture_pg_backup)
    @run_migrations = params.key?(:run_migrations)

    blob_url = CmsDeployer.new(@cmses, @branch).blob_url

    @cmses.each do |cms|
      deploy_params = { app: cms,
                        blob_url: blob_url,
                        capture_backup: @capture_backup,
                        run_migrations: @run_migrations }

      CmsDeployWorker.perform_async(deploy_params)
    end
  end
end
