class AppAddonsWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform
    app_list = AppList.new().get_app_list
    App.all.each do |app|
      if new_app?(app, "addons") || updated_app?(app, app_list)
        addons = AppDetails.new(app.name).get_app_addons
        app.update_attributes({addons: addons})
      end
    end
  end

end