module WorkersHelper
  def new_app?(app, attribute)
    attribute = attribute.to_sym
    app.send(attribute).blank? ? true : false
  end

  def updated_app?(app, app_list)
    api_app = ""
    app_list.each do |app_details|
     api_app = app_details if app_details["name"] == app.name 
    end
    api_app["updated_at"] != app.app_details["updated_at"] ? true : false
  end
end