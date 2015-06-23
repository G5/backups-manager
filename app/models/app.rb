class App < ActiveRecord::Base

  def app_name
    app_details[0]["name"]
  end
  
end