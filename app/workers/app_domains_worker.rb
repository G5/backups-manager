class AppDomainsWorker

  include Sidekiq::Worker

  def perform(apps)
    apps.each do |app|
      domains = AppDetails.new(app.app_details[0]["name"]).get_app_domains
      app.update_attributes({domains: domains})
    end
  end

end