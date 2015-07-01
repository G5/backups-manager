module OrgsHelper
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

end
