class App < ActiveRecord::Base
  def app_name
    app_details["name"]
  end

  def set_name_column
    name = app_details["name"]
  end
  
end