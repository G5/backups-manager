class AppConfigVarsWorker

  include Sidekiq::Worker

  def perform
    App.all.each do |app|
      app_type = app.name.split("-")
      next if app_type.include?("clw")
      config = AppDetails.new(app.name).get_app_config_variables
      app.update_attributes({config_variables: config})
    end
  end

end