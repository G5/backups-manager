require 'open3'

class BackupSchedulesWorker

  HEROKU_BIN_PATH, REGION, BUCKET_NAME, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY =
    ENV["HEROKU_BIN_PATH"], ENV["AWS_REGION"], ENV["S3_BUCKET_NAME"], ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"]

  include Sidekiq::Worker

  def perform
    apps = []
    App.all.each do |app|
      if app.backup_schedule && !app.backup_schedule.include?('No backup schedules found')
        logger.info("AppTest: [#{app.name}] - schedules: #{app.backup_schedule}")
        apps << app
      end
    end
    logger.info("AppCount: #{apps.count}")
  end
  
private

  def open3_capture(url)
    capture_result, stderr, status = Bundler.with_clean_env {Open3.capture3(url)}
    return [capture_result, stderr, status]
  end

end

