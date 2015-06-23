class AppDynosWorker

  include Sidekiq::Worker

  def perform(apps)
    apps.each do |app|
      dynos = AppDetails.new(app.app_details[0]["name"]).get_app_dynos
      app.update_attributes({dynos: dynos})
    end
  end

end