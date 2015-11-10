class CmsPostDeployWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform(app, build_id)
    # The CmsPostDeployWorker is called immediately after the deploy is initiated.
    # So, wait a little bit, then ask Heroku for the deploy status. We only want 
    # to run the post_deploy_tasks if and when this build's status is "succeeded".

    attempts = 0
    status = "pending"

    while attempts < 30 && status == "pending" do
      sleep(10.seconds)
      status = CmsDeployer.build_status(app, build_id)
      attempts += 1
    end

    CmsDeployer.post_deploy_tasks(app) if status.eql?("succeeded")
  end
end