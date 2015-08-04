class SetAppConfigWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform(app_name, var, val)
    app = AppManager.new(app_name)
    app.set_config_variable(var, val)
  end
end
