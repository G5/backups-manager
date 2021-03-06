module PerformanceDashboardHelper
  def wrangle_unhealthy_apps(unhealthy_apps)
    markup = ""
    if !unhealthy_apps[:error_status]
      sorted_apps = sort_unhealthy_apps_by_type(unhealthy_apps)
      sorted_apps.each do |app|
        markup << %Q(<li><a href="javascript:void(0)" class="js-accordion-trigger">#{app[0].upcase} (#{app[1].count})</a><ul class="submenu"><li>)
        app[1].each do |data|
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
        markup << %q(</li></ul></li>)
      end
    else
      markup << content_tag(:p, unhealthy_apps[:status_message])
    end
    markup
  end

  def sort_unhealthy_apps_by_type(apps)
    apps[:unhealthy_apps][:data].compact!
    apps[:unhealthy_apps][:data].group_by {|app| app["name"].split("-")[1]}
  end
end
