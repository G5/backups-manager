class AppWranglerWorker

  include Sidekiq::Worker

  def perform
    create_new_apps
  end

  def create_new_apps
    app_list = AppList.get #hits api once
    app_list.each do |app|
      if App.where(name: app["name"]).blank? #this will not create a new app if it already exists
        organization = Organization.
          where(guid: app["owner"]["id"]).
          first_or_create(email: app["owner"]["email"])
        organization.apps.create!(app_details: app, name: app["name"])
      end
    end
  end
end
