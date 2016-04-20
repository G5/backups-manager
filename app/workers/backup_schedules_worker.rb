require 'open3'

class BackupSchedulesWorker

  HEROKU_BIN_PATH, REGION, BUCKET_NAME, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY =
    ENV["HEROKU_BIN_PATH"], ENV["AWS_REGION"], ENV["S3_BUCKET_NAME"], ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"]

  include Sidekiq::Worker

  def perform
    apps = []
    App.all.each do |app|
      if app.backup_schedule && !app.backup_schedule.include?('No backup schedules found')
        apps << app
      end
    end
    apps.each do |app|
      clean_schedules(app)
    end
  end
  
private

  def get_schedules(app)
    schedules = []
    pg_schedules = app.backup_schedule.split("\n")
    pg_schedules.each do |pg_schedule|
      next if pg_schedule.include?("DATABASE_URL")
      schedules << pg_schedule.slice(/HEROKU\w+/)
    end
    schedules
  end

  def clean_schedules(app)
    schedules = get_schedules(app)
    logger.info(puts "[#{app.name}] non DATABASE_URL schedules (colors): #{schedules}") if schedules.any?
#    schedules.each do |schedule| 
#      next if schedule.include?("DATABASE_URL")
#      pg_info, stderr, status = Bundler.with_clean_env {Open3.capture3("heroku pg:backups unschedule #{sched} -a #{@app_name}")}
#      if status.success?
#        logger.info("[#{app.name}] Unschedule Success: #{schedule}")
#      else
#        logger.info("[#{app.name}] Unschedule Error: #{stderr}")
#      end
#    end
  end
  
  def schedule_and_capture
    pg_schedule = "heroku pg:backups schedule --at '02:00 America/Los_Angeles' DATABASE_URL --app #{@app_name}"
    pg_capture = "heroku pg:backups capture -a #{@app_name}" 
    sched_result = open3_capture(pg_schedule)
    puts "#{sched_result[0]}".green + " as" + " DATABASE_URL".green
    cap_result = open3_capture(pg_capture)
    puts cap_result[0].green
  end

  def open3_capture(url)
    capture_result, stderr, status = Bundler.with_clean_env {Open3.capture3(url)}
    return [capture_result, stderr, status]
  end

end

