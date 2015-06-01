module AppsHelper
  def render_app_groups(order_up)
    markup = ""
    order_up.each do |key, value|
      master_version = @app_list.get_master_version(key.downcase)
      master_version_str = master_version ? "<span class='version'>MASTER: <span class='version-value'>#{master_version}</span></span>" : ""
      markup << "<a name='#{key.downcase.parameterize}'></a>"
      markup << "<h3 class='app-title' id='#{key.downcase.parameterize}'>#{key}#{master_version_str}</h3>" unless value.blank?
      markup << "<ul class='app-list'>" unless value.blank?
      value.each do |v|
        version = "<span class='version'>...</span>" if @app_list.version_apps_list.has_key?(key.downcase)
        markup << "<li>#{link_to v, app_path(v)}#{version}</li>"
      end
      markup << "</ul>" unless value.blank?
      markup << "<hr />" unless value.blank?
    end
    markup.html_safe
  end
end