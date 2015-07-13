class RemoveDeletedAppWorker
  def perform
    remove_deleted_app
  end

  def remove_deleted_app
    app_list = AppList.new().get_app_list #hits api once
    apps_in_database = App.all

    apps_in_database.each do |app|
      app_list.each do |happ|
        happ["name"]
      end
    end 
  end
end