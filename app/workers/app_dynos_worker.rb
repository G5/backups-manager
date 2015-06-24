class AppDynosWorker

  include Sidekiq::Worker

  def perform
    App.all.each do |app|
      dynos = AppDetails.new(app.app_details["name"]).get_app_dynos
      app.update_attributes({dynos: dynos})
    end
  end

end