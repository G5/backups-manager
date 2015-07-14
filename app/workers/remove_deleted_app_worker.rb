class RemoveDeletedAppWorker
  
  include Sidekiq::Worker

  def perform
    remove_deleted_app
  end

  def remove_deleted_app
    app_list = AppList.get #hits api once
    apps_on_heroku = app_list.map {|app| app["name"]}
    apps_in_database = App.all.map {|app| app.name}

    apps_in_database.each do |app|
      if apps_on_heroku.exclude?(app)
        dead_app = App.find_by_name(app)
        App.destroy(dead_app.id)
      end
    end 
  end
end