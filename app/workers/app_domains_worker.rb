class AppDomainsWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform
    app_list = AppList.get
    App.all.each do |app|
      if new_app?(app, "domains") || updated_app?(app, app_list)
        domains = AppDetails.new(app.name).get_app_domains
        app.update_attributes({domains: domains})
      end
    end
  end
end
