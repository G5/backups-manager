class CashController < ApplicationController
  def index
    # Brutal. Can't find a sane way to get PG to do this for me, though.
    @database_plans = App.all.map(&:database_plans).flatten.uniq

    if params[:database_plan_id].present?
      @apps = App.all_by_database_plan(params[:database_plan_id])
    end
  end
end
