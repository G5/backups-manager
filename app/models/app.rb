class App < ActiveRecord::Base

  def app_name
    app_details["name"]
  end
  
end