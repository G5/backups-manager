module OrgsHelper

  def get_app_type(app)
    type_array = app.name.split("-")
    type = ""
    AppVersions.app_list.each do |key, value|
      type = key if type_array.include?(key)
    end
    type
  end

end
