require 'open3'

class AppDatabaseMover
  HEROKU_BIN_PATH, REGION, BUCKET_NAME, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY =
    ENV["HEROKU_BIN_PATH"], ENV["AWS_REGION"], ENV["S3_BUCKET_NAME"], ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"]
  
  include Sidekiq::Worker

  def perform(app_id)#, heroku_bin_path, region, bucket_name, aws_access_key_id, aws_secret_access_key)
    app = App.find(app_id)
    run_backups(app)
  end

private

  def run_backups(app)
    Aws.config.update({
      region: REGION,
      credentials: Aws::Credentials.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
    })
    system_command = "#{HEROKU_BIN_PATH} pg:backups public-url -a #{app.name}"
    public_url, stdeerr, status = Bundler.with_clean_env {Open3.capture3(system_command)}
    return unless status.success?
    public_url.strip!
    system_command = "curl -o #{Rails.root.join('tmp', app.name)} '#{public_url}'"
    Bundler.with_clean_env {system "#{system_command}"}
    backup = File.open("#{Rails.root.join('tmp',app.name)}")   
    if send_backup_to_s3(backup,app.name)
      app.backup_transfer_success = true 
    else
      app.backup_transfer_success = false 
    end
    app.save
  end
  
  def send_backup_to_s3(backup, bucket_key)
    s3 = Aws::S3::Resource.new(region: REGION)
    bucket = s3.bucket(BUCKET_NAME)
    begin
      bucket.put_object({ body: backup, key: bucket_key})
      logger.info("#{app.name} file saved to S3.")
      true
    rescue => e
      logger.info("Failed to Save to S3. Error: #{e}")
      false
    end
  end

  def check_backup_schedule
    schedule_check = "#{HEROKU_BIN_PATH} pg:backups public-url -a #{app.name}"

  end

  def get_public_url

  end

end
