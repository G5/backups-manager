class AdminController < ApplicationController

  before_filter :authenticate_user!, :verify_admin

  def index
  end

  def batch_delete
    @death_row_apps = params['apps'].split(',').map(&:strip)

    @death_row_apps.each do |app|
      AppDeleteWorker.perform_async(app)
    end
  end

  def batch_spin_down
    @sleepy_apps = params['apps'].split(',').map(&:strip)

    @sleepy_apps.each do |app|
      AppSpinDownWorker.perform_async(app)
    end
  end

  def batch_config
    @config_apps = params['apps'].split(',').map(&:strip)
    @config_var = params['config_variable']
    @config_val = params['config_value']

    @config_apps.each do |app|
      SetAppConfigWorker.perform_async(app, @config_var, @config_val)
    end
  end
end
