class AppWranglerWorker

  include Sidekiq::Worker

  def perform
    create_new_apps
  end

  def create_new_apps
    app_list = AppList.get #hits api once
    app_list.each do |h|
      o = find_or_create_organization(h)
      app = App.find_by_name(h["name"])

      if !app.present?
        o.apps.create!(app_details: h, name: h["name"])
      else
        if app.organization != o
          app.organization = o
          app.save!
        end
      end
    end
  end

protected

  def find_or_create_organization(app_hash)
    Organization.
      where(guid: app_hash["owner"]["id"]).
      first_or_create(email: app_hash["owner"]["email"])
  end
end
