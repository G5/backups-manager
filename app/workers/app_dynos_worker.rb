class AppDynosWorker

  include Sidekiq::Worker

  def perform
    App.all.each do |app|
      dynos = AppDetails.new(app.name).get_app_dynos
      app.update_attributes({dynos: dynos})
    end
  end

end