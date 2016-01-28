require 'open3'

class AppDatabaseMover

  include Sidekiq::Worker

  def perform(app_id, heroku_bin_path, region, bucket_name)
    app = App.find(app_id) 
    run_backups(app, heroku_bin_path, region, bucket_name)
  end

private

  def run_backups(app, heroku_bin_path, region, bucket_name)
    system_command = "#{heroku_bin_path} pg:backups public-url -a #{app.name}"

    #Rails.logger.info("getting public-url") ##!

    logger.info("running command: #{system_command}")
    public_url, stdeerr, status = Bundler.with_clean_env {Open3.capture3(system_command)}
    logger.info("done")

    logger.info("got public url value of: #{public_url}")
    #public_url = Bundler.with_clean_env {system "#{system_command}"}
    logger.info("app: #{app.name}")
    return unless status.success?
    public_url.strip!

    #Rails.logger.info("had backups") ##!


    system_command = "curl -o #{Rails.root.join('tmp', app.name)} '#{public_url}'"
    
    #Rails.logger.info("downloading dump") ##!

    Bundler.with_clean_env {system "#{system_command}"}
    s3 = Aws::S3::Resource.new(region: region)
    bucket = s3.bucket(bucket_name)

    #Rails.logger.info("uploading to s3") ##!

    upload_result = bucket.put_object({ body: File.open("#{Rails.root.join('tmp',app.name)}"), 
                                 key: "#{app.name}"})

    #Rails.logger.info("result: #{upload_result.to_s}") ##!
  end
end

