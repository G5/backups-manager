class AppAddonsWorker

  include Sidekiq::Worker

  def perform
    app_list = AppList.new().get_app_list
    App.all.each do |app|
      addons = AppDetails.new(app.name).get_app_addons
      app.update_attributes({addons: addons})
    end
  end

end