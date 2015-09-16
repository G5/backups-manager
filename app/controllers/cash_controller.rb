class CashController < ApplicationController
  def index
    # Brutal. Can't find a sane way to get PG to do this for me, though.
    @database_plans = App.all.map(&:database_plans).flatten.uniq

    if params[:commit] == "Has SSL Add-on?"
      # This form isn't fancy, we're not chaining queries around here.
      params[:database_plan_id] = ""
      @apps = App.all_with_addon('ssl', 'ssl:endpoint')
    elsif params[:database_plan_id].present?
      full_plan_id = "heroku-postgresql:" + params[:database_plan_id]
      @apps = App.all_with_addon('heroku-postgresql', full_plan_id)
    end
  end
end
