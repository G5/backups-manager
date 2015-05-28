class AdminController < ApplicationController

  before_filter :authenticate_user!, :verify_admin

  def index
  end

  def batch_delete
    @death_row_apps = params['apps'].split(',').map(&:strip)

    @death_row_apps.each do |app|
      Resque.enqueue(AppDelete, app)
    end
  end

  def batch_spin_down
    @sleepy_apps = params['apps'].split(',').map(&:strip)

    @sleepy_apps.each do |app|
      Resque.enqueue(AppSpinDown, app)
    end
  end
end
