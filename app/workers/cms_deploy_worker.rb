class CmsDeployWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform(blob_url, app)
    CmsDeployer.deploy(blob_url, app)
  end
end
