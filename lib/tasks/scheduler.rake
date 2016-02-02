desc "This task is called by the Heroku scheduler add-on"

task :backup_db_backups => :environment do
  AppUpdaterWorker.perform_async
  App.all.each do |app|
    AppDatabaseMover.perform_async(app.id)
  end
end

task :update_app_list => :environment do
  AppUpdaterWorker.perform_async
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

task :update_organization_invoices => :environment do
  OrganizationInvoiceWorker.perform_async
end

task :update_performance_data => :environment do
  PerformanceDashboardWorker.perform_async
end

task :update_g5ops_health => :environment do
  AppHealthStatusWorker.perform_async
end
