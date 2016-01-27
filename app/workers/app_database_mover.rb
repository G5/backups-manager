class AppDatabaseMover

  include Sidekiq::Worker

  def perform(app_id)
    app = App.find(app_id) 
    run_backups(app)
  end

private

  def run_backups(app)
    system_command = "#{ENV['HEROKU_BIN_PATH']} pg:backups public-url -a #{app.name}"

    #Rails.logger.info("getting public-url") ##!

    public_url = Bundler.with_clean_env {`#{system_command}`}
    return if public_url.blank?
    return if public_url.include?('No backups')
    public_url.strip!

    #Rails.logger.info("had backups") ##!


    system_command = "curl -o #{Rails.root.join('tmp', app.name)} '#{public_url}'"
    
    #Rails.logger.info("downloading dump") ##!

    Bundler.with_clean_env {`#{system_command}`}
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(ENV['S3_BUCKET_NAME'])

    #Rails.logger.info("uploading to s3") ##!

    upload_result = bucket.put_object({ body: File.open("#{Rails.root.join('tmp',app.name)}"), 
                                 key: "#{app.name}"})

    #Rails.logger.info("result: #{upload_result.to_s}") ##!
  end
end

