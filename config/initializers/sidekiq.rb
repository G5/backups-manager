Sidekiq.default_worker_options = {
  unique: :until_executed,
  retry: 5
}
