class AppSpinDown
  @queue = :shut_downs

  def self.perform(app_name)
    app = AppDetails.new(app_name)
    app.spin_down
  end
end
