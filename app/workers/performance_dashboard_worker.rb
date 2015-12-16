class PerformanceDashboardWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform
    # starting from here
    PerformanceData.new_relic_data
    PerformanceData.pagerduty_oncall
    PerformanceData.pagerduty_incidents
  end

end
