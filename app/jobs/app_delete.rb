class AppDelete
  @queue = :deletions

  def self.perform(app_name)
    app = AppDetails.new(app_name)
    app.delete
  end
end
