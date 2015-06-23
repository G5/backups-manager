class AppAddonsWorker

  include Sidekiq::Worker

  def perform(apps)
    apps.each do |app|
      addons = AppDetails.new(app.app_details[0]["name"]).get_app_addons
      app.update_attributes({addons: addons})
    end
  end

end