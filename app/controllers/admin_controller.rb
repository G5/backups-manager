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
end
