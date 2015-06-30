class App < ActiveRecord::Base
  after_create :set_name_column

  def app_name
    app_details["name"]
  end

  def set_name_column
    name = app_details["name"]
  end
  
end