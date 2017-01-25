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
      app = App.find_by_name(h["name"])
        if app.blank?
          o.apps.create!(app_details: h, name: h["name"]) unless skip_app(h)
        else
          app.organization != o
          app.organization = o
          app.save!
        end
      end
    end

  def skip_app(app)
    # skip the app if it doesn't belong to an organization
    return true unless app["organization"]

    # skip the app if it's name contains "g5-clwo, or redirect"
    return true if app["name"].match(/g5-clw|redirect/)

    # skip app if it is a member of listed organizations
    return true if app["organization"]["name"].match(/g5-test-apps|g5-test-apps|g5-tests-apps2|g5-sales-demo|g5-sales-demo-2|g5-test-clients|g5-test-clients2|mjstorage|sockeye|la.team/)
  end


  def find_or_create_organization(app_hash)
    org = Organization.
      where(guid: app_hash["owner"]["id"]).
      first_or_create(email: app_hash["owner"]["email"])
    org.update_attribute(:name,  org.get_name)
    org
  end
end
