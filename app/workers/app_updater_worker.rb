class AppUpdaterWorker

  include Sidekiq::Worker

  def perform(callback)
    create_new_apps
    eval(callback)
  end

private

  def create_new_apps
    App.destroy_all
    app_list = AppList.get #hits api once
    logger.info("Applist Response: #{app_list["message"]}") if app_list.first.include?("unauthorized")
    app_list.each do |h|
      o = find_or_create_organization(h)
      next if h["name"].include?("g5-clw")
      app = App.find_by_name(h["name"])
      if app.blank? 
        o.apps.create!(app_details: h, name: h["name"])
      else
        if app.organization != o
          app.organization = o
          app.save!
        end
      end
    end
  end

  def find_or_create_organization(app_hash)
    org = Organization.
      where(guid: app_hash["owner"]["id"]).
      first_or_create(email: app_hash["owner"]["email"])
    org.update_attribute(:name,  org.get_name)
    org
  end
end

