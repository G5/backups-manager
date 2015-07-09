class AppWranglerWorker

  include Sidekiq::Worker

  def perform
    create_new_apps
  end

  def create_new_apps
    app_list = AppList.new().get_app_list #hits api once
    app_list.each do |app|
      if App.where(name: app["name"]).blank? #this will not create a new app if it already exists
        attributes = {app_details: app, name: app["name"]}
        App.create(attributes)
      end 
    end
  end
end
