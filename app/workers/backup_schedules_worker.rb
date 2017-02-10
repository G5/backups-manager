require 'open3'

class BackupSchedulesWorker

  HEROKU_BIN_PATH, REGION, BUCKET_NAME, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY =
    ENV["HEROKU_BIN_PATH"], ENV["AWS_REGION"], ENV["S3_BUCKET_NAME"], ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"]

  include Sidekiq::Worker

  def perform(app_id)
    app = App.find(app_id)
    clean_schedules(app)
    add_schedule(app)
  end

private

  def get_schedules(app)
    schedules = []
    return schedules if app.backup_schedule.nil?
    pg_schedules = app.backup_schedule.split("\n")
    pg_schedules.each do |pg_schedule|
      next if pg_schedule.include?("DATABASE_URL")
      schedules << pg_schedule.slice(/HEROKU\w+/)
    end
    schedules
  end

  def clean_schedules(app)
    schedules = get_schedules(app)
    logger.info("[#{app.name}] - #{schedules}") if schedules.any?
    schedules.each do |schedule|
      pg_info, stderr, status = Bundler.with_clean_env {Open3.capture3("#{HEROKU_BIN_PATH} pg:backups:unschedule #{schedule} -a #{app.name}")}
      logger.info("[#{app.name}][#{schedule}] - #{pg_info} - #{stderr} - #{status}")
      if status.success?
        logger.info("[#{app.name}] unschedule success: #{schedule}")
      else
        logger.info("[#{app.name}] unschedule error: #{stderr}")
      end
    end
  end

  def add_schedule(app)
    pg_schedule = "#{HEROKU_BIN_PATH} pg:backups:schedule --at '02:00 America/Los_Angeles' DATABASE_URL --app #{app.name}"
    sched_result = open3_capture(pg_schedule)
    logger.info("#{sched_result[1]}")
  end

  def open3_capture(url)
    capture_result, stderr, status = Bundler.with_clean_env {Open3.capture3(url)}
    return [capture_result, stderr, status]
  end

end
