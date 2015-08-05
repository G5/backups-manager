class AppSpinDownWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform(app_name)
    app = AppManager.new(app_name)
    app.spin_down
  end
end
