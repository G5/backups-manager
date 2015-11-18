class AppHealthStatusWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform
    cache_unhealthy_apps
  end

  def cache_unhealthy_apps
    redis.set("g5ops:health", g5_unhealthy_apps.to_json)
  end

  def g5_unhealthy_apps
    unhealthy_apps = App.all.map do |app|
      begin
        response = HTTPClient.
                   get("#{app["app_details"]["web_url"]}g5_ops/status.json")
        parsed_body = JSON.parse response.body
        if parsed_body["health"]["OVERALL"]["is_healthy"] == false
          {
            name: app["app_details"]["name"],
            health: parsed_body["health"]
          }
        end
      rescue => e
        puts "#{e}"
      end
    end
    unhealthy_apps
  end

  private

  def redis
    @redis ||= Redis.new
  end
end
