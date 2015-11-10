class CmsDeployWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform(options)
    CmsDeployer.capture_backup(options['app']) if options['capture_backup']
    build_id = CmsDeployer.deploy(options['blob_url'], options['app'])

    # Now fire off a new job that runs post deploy tasks if we're running migrations, and CmsDeployer(options['app'], build_id) == "succeeded"
    CmsPostDeployWorker.perform_async(options['app'], build_id) if options['run_migrations']
  end
end
