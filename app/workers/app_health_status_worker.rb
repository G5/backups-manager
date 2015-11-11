class AppHealthStatusWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform
    cache_unhealthy_apps
  end
  
  def cache_unhealthy_apps
    unhealthy_apps = g5_unhealthy_apps
    redis.set("g5ops:health", unhealthy_apps.to_json)
  end

  def g5_unhealthy_apps
    unhealthy_apps = App.all.map do |app|
      begin
        response = HTTPClient.
                   get("#{app["app_details"]["web_url"]}g5_ops/status.json")
        parsed_body = JSON.parse response.body
        puts "mapping *******#{app['name']}***********"
        {
          name: app["name"],
          health: parsed_body["database"],
          widgets: parsed_body["widgets"],
          overall: parsed_body["OVERALL"]
        }
      rescue => e
        puts "#{e}"
      end
      puts "#{unhealthy_apps}"
    end
    unhealthy_apps
  end

  private

  def redis
    @redis ||= Redis.new
  end
end
