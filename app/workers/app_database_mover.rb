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


    public_url, stderr, status = get_public_url(app)
    if status.success?
      public_url.strip!
    else
      app.backup_transfer_success=false
      app.touch
      app.save
      raise "Could not get public_url for #{app.name}"
    end

    schedule, stderr, status = check_backup_schedule(app)
    if status.success?
      app.backup_schedule = schedule
      app.save
    else
      app.touch; app.save
      raise "Could not check the schedule, or no scheduled backups"
    end

    schedule, stderr, status = download_backup(app, public_url)
    if status.success?
      backup = File.open("#{Rails.root.join('tmp',app.name)}")   
    else
      raise "Could not download the backup"
    end

    options = { body: backup, key: app.name, metadata: { pg_backup_date: last_backup_date(app) } }
    if send_file_to_s3(options)
      app.backup_transfer_success = true 
      app.touch; app.save
    else
      app.backup_transfer_success = false 
      app.touch; app.save
      raise "Could not upload the backup to s3"
    end
  end

  def download_backup(app, public_url)
    system_command = "curl -o #{Rails.root.join('tmp', app.name)} '#{public_url}'"
    output, stderr, status = run_system_command(system_command)
  end

  # more info at: http://docs.aws.amazon.com/sdkforruby/api/Aws/S3/Client.html#put_object-instance_method
  # put_object accepts keys like `body` (for file), `key`, `metadata` (as a hash)
  def send_file_to_s3(options) 
    s3 = Aws::S3::Resource.new(region: REGION)
    bucket = s3.bucket(BUCKET_NAME)
    begin
      bucket.put_object(options)
      true
    rescue => e
      false
    end
  end

  def get_public_url(app)
    get_public_url = "#{HEROKU_BIN_PATH} pg:backups public-url -a #{app.name}"
    public_url, stderr, status = run_system_command(get_public_url)
  end

  def check_backup_schedule(app)
    schedule_check_command = "#{HEROKU_BIN_PATH} pg:backups schedules -a #{app.name}"
    schedule, stderr, status = run_system_command(schedule_check_command)
    [schedule, stderr, status]
  end

  def last_backup_date(app)
    backup_info = "#{HEROKU_BIN_PATH} pg:backups info -a #{app.name}"
    backup_data, stderr, status = run_system_command(backup_info)
    if status.success?
      backup_time = backup_data.match(/^Finished:\s*(.*)/).captures.first
    else
      ''
    end
  end

  def run_system_command(command)
    Bundler.with_clean_env {Open3.capture3(command)}
  end

end
