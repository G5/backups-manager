class CmsDeployWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform(blob_url, app)
    CmsDeployer.capture_backup(app)
    CmsDeployer.deploy(blob_url, app)
    CmsDeployer.post_deploy_tasks(app)
  end
end
