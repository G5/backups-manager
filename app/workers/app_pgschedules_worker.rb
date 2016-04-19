require 'open3'

class AppPgschedulesWorker


  HEROKU_BIN_PATH, REGION, BUCKET_NAME, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY =
    ENV["HEROKU_BIN_PATH"], ENV["AWS_REGION"], ENV["S3_BUCKET_NAME"], ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"]

  include Sidekiq::Worker

  def perform(app_id)
    app = App.find(app_id)
    logger.info("#{[app.name]} Backup Schedule Update"
  end

end

