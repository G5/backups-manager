desc "This task is called by the Heroku scheduler add-on"

task :update_app_list => :environment do
  AppWranglerWorker.perform_async
end

task :update_dynos => :environment do
  AppDynosWorker.perform_async
end

task :update_domains => :environment do
  AppDomainsWorker.perform_async
end

task :update_addons => :environment do
  AppAddonsWorker.perform_async
end

task :update_config_vars => :environment do
  AppConfigVarsWorker.perform_async
end

task :remove_deleted_apps => :environment do
  RemoveDeletedAppWorker.perform_async
end

task :update_cms_configs => :environment do
  CmsConfigWorker.perform_async
end