class AppWranglerWorker

  include Sidekiq::Worker

  def perform
    create_and_update_apps
  end

  def create_and_update_apps
    app_list = AppList.new().get_app_list
    app_list.each do |app|
      #Query data base for an app with the json name attribute
      app_query = App.where("app_details->>'name' = ?", app["name"])
      #This returns an active record relation, so check if its blank, if so, it doesn't exist yet and needs to be created
      if app_query[0].blank?
        attributes = {app_details: app}
        App.create(attributes)
      #Otherwise check the matching app for any changes and update the attributes
      elsif app_query[0].app_details["updated_at"] != app["updated_at"] 
        attributes = get_the_package(app["name"])
        App.update_attributes(attributes)
      end
    end
  end

  def get_the_package(app_name)
    dynos = AppDetails.new(app_name).get_app_dynos
    addons = AppDetails.new(app_name).get_app_addons
    config_vars = AppDetails.new(app_name).get_app_config_variables
    domains = AppDetails.new(app_name).get_app_domains
    attributes = {app_details: app, dynos: dynos, addons: addons, config_variables: config_vars, domains: domains}
  end

end