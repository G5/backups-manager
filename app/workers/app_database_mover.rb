require 'open3'

class AppDatabaseMover
  HEROKU_BIN_PATH, REGION, BUCKET_NAME, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY =
    ENV["HEROKU_BIN_PATH"], ENV["AWS_REGION"], ENV["S3_BUCKET_NAME"], ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"]
  
  include Sidekiq::Worker

  def perform(app_id)#, heroku_bin_path, region, bucket_name, aws_access_key_id, aws_secret_access_key)
    app = App.find(app_id)
    run_backups(app, HEROKU_BIN_PATH, REGION, BUCKET_NAME, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
  end

private

  def run_backups(app, heroku_bin_path, region, bucket_name, aws_access_key_id, aws_secret_access_key)
    Aws.config.update({
      region: region,
      credentials: Aws::Credentials.new(aws_access_key_id, aws_secret_access_key)
    })
    system_command = "#{heroku_bin_path} pg:backups public-url -a #{app.name}"
    public_url, stdeerr, status = Bundler.with_clean_env {Open3.capture3(system_command)}
    return unless status.success?
    public_url.strip!
    system_command = "curl -o #{Rails.root.join('tmp', app.name)} '#{public_url}'"
    Bundler.with_clean_env {system "#{system_command}"}
    s3 = Aws::S3::Resource.new(region: region)
    bucket = s3.bucket(bucket_name)
    begin
      bucket.put_object({ body: File.open("#{Rails.root.join('tmp',app.name)}"), key: "#{app.name}"})
      app.backup_transfer_success = true 
      logger.info("#{app.name} file saved to S3.")
    rescue => e
      app.backup_transfer_success = false 
      logger.info("Failed to Save to S3. Error: #{e}")
    end
    app.save
  end
end
