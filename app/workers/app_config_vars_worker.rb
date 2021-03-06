class AppConfigVarsWorker
  include Sidekiq::Worker
  include WorkersHelper
  
  def perform
    app_list = AppList.get
    App.all.each do |app|
      app_type = app.name.split("-")
      next if app_type.include?("clw")
      if new_app?(app, "config_variables") || updated_app?(app, app_list)
        config = AppDetails.new(app.name).get_app_config_variables
        app.update_attributes({config_variables: config})
      end
    end
  end
end
