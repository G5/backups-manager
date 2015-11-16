module PerformanceDashboardHelper
  def wrangle_unhealthy_apps(unhealthy_apps)
    markup = ""
    sorted_apps = sort_unhealthy_apps_by_type(unhealthy_apps)
    sorted_apps.each do |app|
      markup << %Q(<li><a href="javascript:void(0)" class="js-accordion-trigger">#{app[0].upcase} (#{app[1].count})</a><ul class="submenu"><li>)
      app[1].each do |data|
        if data.is_a?(Hash)
          markup << %q(<div class='tooltip-item'>)
          markup << %Q(#{data["name"]}) ? !data["name"].nil? : "App With No Name"
          markup << %q(<div class='tooltip'>)
          data["health"].each do |vital, sign|
            if sign["is_healthy"] == false
              markup << %Q(<h6>#{vital.upcase}: </h6>) unless vital == "OVERALL"
              markup << %Q(<p>#{sign["message"]}</p>)
            end
          end
          markup << %q(</div>)
          markup << %q(</div>)
        end
      end
      markup << %q(</li>)
      markup << %q(</ul>)
      markup << %q(</li>)
    end
    markup
  end

  def sort_unhealthy_apps_by_type(apps)
    sorted_apps = apps.group_by { |app| app["name"].split("-")[1] } 
    sorted_apps
  end
end
