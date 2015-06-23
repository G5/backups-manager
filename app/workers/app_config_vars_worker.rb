class AppConfigVarsWorker

  include Sidekiq::Worker

  def perform(apps)
    apps.each do |app|
      config = AppDetails.new(app.app_details[0]["name"]).get_app_config_variables
      app.update_attributes({config_variables: config})
    end
  end

end