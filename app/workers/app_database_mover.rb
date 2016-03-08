require 'open3'
require 'csv'

class AppDatabaseMover
  HEROKU_BIN_PATH, REGION, BUCKET_NAME, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY =
    ENV["HEROKU_BIN_PATH"], ENV["AWS_REGION"], ENV["S3_BUCKET_NAME"], ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"]
  
  include Sidekiq::Worker

  def perform(app_id)
    app = App.find(app_id)
    run_backups(app)
  end

private

  def run_backups(app)
    Aws.config.update({
      region: REGION,
      credentials: Aws::Credentials.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
    })
    get_public_url = "#{HEROKU_BIN_PATH} pg:backups public-url -a #{app.name}"
    public_url, stdeerr, status = Bundler.with_clean_env {Open3.capture3(get_public_url)}
    CSV.open("job_log.csv","a") {|csv| csv << [app.name, public_url, stdeerr, status, status.success?] }
    logger.info("success from get public_url: #{status.to_s}")
    unless status.success?
      app.backup_transfer_success=false
      app.touch
      app.save
      raise "Could not get public_url for #{app.name}"
    end
    public_url.strip!
    check_backup_schedule(app)
    system_command = "curl -o #{Rails.root.join('tmp', app.name)} '#{public_url}'"
    Bundler.with_clean_env {system "#{system_command}"}
    backup = File.open("#{Rails.root.join('tmp',app.name)}")   
    options = { body: backup, key: app.name, metadata: { pg_backup_date: last_backup_date(app) } }
    if send_backup_to_s3(options)
      app.backup_transfer_success = true 
    else
      app.backup_transfer_success = false 
    end
    app.touch
    app.save
  end
  
  def send_backup_to_s3(options)
    s3 = Aws::S3::Resource.new(region: REGION)
    bucket = s3.bucket(BUCKET_NAME)
    begin
      bucket.put_object(options)
      logger.info("#{options[:key]} file saved to S3.")
      true
    rescue => e
      logger.info("#{options[:key]} failed to save to S3. Error: #{e}")
      false
    end
  end

  def check_backup_schedule(app)
    schedule_check = "#{HEROKU_BIN_PATH} pg:backups schedules -a #{app.name}"
    schedule, stdeerr, status = Bundler.with_clean_env {Open3.capture3(schedule_check)}
    if status.success?
      app.backup_schedule = schedule if status.success?
      app.save
    else
      logger.info("schedule check failed, #{stdeerr}")
    end
    logger.info("#{app.backup_schedule}")
  end

  def last_backup_date(app)
    backup_info = "#{HEROKU_BIN_PATH} pg:backups info -a #{app.name}"
    backup_data, stdeerr, status = Bundler.with_clean_env {Open3.capture3(backup_info)}
    if status.success?
      backup_time = backup_data.match(/^Finished:\s*(.*)/).captures.first
      app.pgbackup_date = backup_time
      app.save
    else
      logger.info("backups date check failed, #{stdeerr}")
      app.pgbackup_date = "none"
      app.save
      ''
    end
  end

end
