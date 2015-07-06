# Use this file to easily define all of your cron jobs.

# Learn more: http://github.com/javan/whenever


# *********UTC Time Zone For Heroku Servers************
every 1.day, :at => '7:00 am' do
  runner "AppWranglerWorker.perform_async"
end

every 1.day, :at => '8:00 am' do
  runner "AppAddonsWorker.perform_async"
end

every 1.day, :at => '9:00 am' do
  runner "AppConfigVarsWorker.perform_async"
end

every 1.day, :at => '10:00 am' do
  runner "AppDomainsWorker.perform_async"
end

every 1.day, :at => '11:00 am' do
  runner "AppDynosWorker.perform_async"
end
