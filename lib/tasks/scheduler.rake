desc "This task is called by the Heroku scheduler add-on"

task :backup_the_backups => :environment do
  AppUpdaterWorker.perform_async("App.all.each {|app| AppDatabaseMover.perform_async(app.id)}")
  #CSV.open("job_log.csv", "a") {|csv| csv << ["Starting Job Log - #{DateTime.now}"] }
end

task :fix_backup_schedules => :environment do
  apps = []
  App.all.each do |app|
    if !app.backup_schedule || app.backup_schedule.include?('No backup schedules found')
      apps << app
    end
  end
  apps.each {|app| BackupSchedulesWorker.perform_async(app.id) }
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
