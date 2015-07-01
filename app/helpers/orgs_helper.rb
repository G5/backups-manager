module OrgsHelper
  def render_org_groups(order_up)
    markup = ""
    order_up.each do |group|
      key = group[0]
      value = group[1]
      markup << anchor_str(key)
      markup << org_title_str(key, value)
      markup << "<ul class='app-list'>" 
      value.each do |app|
        markup << org_item_str(key, value, app)
      end unless value.blank?
      markup << "</ul>"
    end
    markup.html_safe
  end

  def master_version_inputs
    version_apps_list.inject("") do |str, (key, value)|
      master_version = get_master_version(key)
      str << "<input type='hidden' id='master-version-#{key}' value='#{master_version}'>"
      str
    end.html_safe
  end

  def get_app_type(app)
    type_array = app.name.split("-")
    type = ""
    version_apps_list.each do |key, value|
      type = key if type_array.include?(key)
    end
    type
  end

  def org_title_str(key, value)
    "<h3 class='app-title' id='#{key_slug(key)}'><span class='app-name'>#{key}</span>#{count_str(value)}</h3>" unless value.blank?
  end

  def org_version_str(appname)
    type = get_app_version_type(appname)
    if type
      mv = AppList.get_master_version(type)
      "<span class='version' data-type='#{type}'><span class='version-value'>...</span> (<span class='master-value'>#{mv}</span>)</span>"
    end
  end

  def org_item_str(key, value, app)
    aname = app['name']
    "<li>#{app_link_str(aname)}#{heroku_dashboard_link_str(aname)}#{heroku_app_link_str(aname)}#{org_version_str(aname)}</li>"
  end
end
