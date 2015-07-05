class AppAddonsWorker

  include Sidekiq::Worker

  def perform
    App.all.each do |app|
      addons = AppDetails.new(app.name).get_app_addons
      app.update_attributes({addons: addons})
    end
  end

end