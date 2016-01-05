module PerformanceDashboardHelper
  def wrangle_unhealthy_apps(unhealthy_apps)
    markup = ""
    if !unhealthy_apps[:status_message]
      sorted_apps = sort_unhealthy_apps_by_type(unhealthy_apps)
      sorted_apps.each do |app|
        markup << %Q(<li><a href="javascript:void(0)" class="js-accordion-trigger">#{app[0].upcase} (#{app[1].count})</a><ul class="submenu"><li>)
        app[1].each do |data|
          if data.is_a?(Hash)
            markup << %q(<div class='tooltip-item'>)
            markup << data["name"] ? !data["name"].nil? : "App With No Name"
            markup << %q(<div class='tooltip'>)
            data["health"].each do |vital, sign|
              if sign["is_healthy"] == false
                markup << %Q(<h6>#{vital.upcase}: </h6>) unless vital == "OVERALL"
                markup << %Q(<p>#{sign["message"]}</p>)
              end
            end
            markup << %q(</div></div>)
          end
        end
        markup << %q(</li></ul></li>)
      end
    else
      markup << content_tag(:p, unhealthy_apps[:status_message])
    end
    markup
  end

  def sort_unhealthy_apps_by_type(apps)
    apps[:data].delete_if {|app| app.nil?}
    apps[:data].group_by {|app| app["name"].split("-")[1]}
  end

  def expired_incidents(incidents)
    living_incidents = $redis.keys.select { |key| key.include?("pagerduty:incidents") }
    dead_incidents = []
    living_incidents.each do |alive|
      incidents.each do |i|
        unless i[1]["incident_number"].to_s == alive.split(":")[2]
          dead_incidents << i[1]["incident_number"]
        end
      end
    end
    dead_incidents
  end
end
