class PerformanceDashboardWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform
    # starting from here
    PerformanceData.new_relic_data
    PerformanceData.pagerduty_oncall
  end

end
