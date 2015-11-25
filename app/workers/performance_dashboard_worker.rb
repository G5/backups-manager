class PerformanceDashboardWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform
    PerformanceData.new_relic_data
    PerformanceData.pagerduty_oncall
    PerformanceData.pagerduty_incidents
  end

end
