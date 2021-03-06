class AppDynosWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform
    app_list = AppList.get
    App.all.each do |app|
      if new_app?(app, "dynos") || updated_app?(app, app_list)
        dynos = AppDetails.new(app.name).get_app_dynos
        app.update_attributes({dynos: dynos})
      end
    end
  end
end
