class AppDomainsWorker

  include Sidekiq::Worker

  def perform
    App.all.each do |app|
      domains = AppDetails.new(app.name).get_app_domains
      app.update_attributes({domains: domains})
    end
  end

end