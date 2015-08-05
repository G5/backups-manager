class AppDeleteWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform(app_name)
    app = AppManager.new(app_name)
    app.delete
  end
end
