module AppsHelper
  def render_app_groups(order_up)
    markup = ""
    order_up.each do |key, value|
      master_version = AppList.get_master_version(key.downcase)
      master_version_str = master_version ? "<span class='version'>MASTER: <span class='version-value'>#{master_version}</span></span>" : ""
      markup << apps_title_str(key, value, master_version_str)
      markup << "<ul class='app-list'>" unless value.blank?
      value.each do |app|
        markup << app_item_str(key, value, app)
      end
      markup << "</ul>" unless value.blank?
    end
    markup.html_safe
  end

  def apps_title_str(key, value, master_version_str="")
    "<h3 class='app-title' id='#{key_slug(key)}'><span class='app-name'>#{key}</span>#{count_str(value)}#{master_version_str}</h3>" unless value.blank?
  end

  def app_version_str(key)
    "<span class='version'><span class='version-value'>...</span></span>" if AppList.version_apps_list.has_key?(key)
  end

  def app_item_str(key, value, app)
    "<li>#{app_link_str(app)}#{heroku_dashboard_link_str(app)}#{heroku_app_link_str(app)}#{app_version_str(key_slug(key))}</li>"
  end
end