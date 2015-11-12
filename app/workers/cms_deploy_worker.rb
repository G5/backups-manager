class CmsDeployWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform(options)
    if options['capture_backup']
      CmsDeployer.capture_backup(options['app'])
      DeployNotification.new(options['app'], "Backed Up", options['pusher_channel'])
    end

    build_id = CmsDeployer.deploy(options['blob_url'], options['app'])

    CmsPostDeployWorker.perform_async(options, build_id) if build_id
  end
end
