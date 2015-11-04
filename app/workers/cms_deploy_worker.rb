class CmsDeployWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform(app_name, branch = "master")
    tar_ball = CmsTarBall.new(app_name, branch)
    tar_ball.deploy_to_heroku
  end
end
