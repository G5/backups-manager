module ApplicationHelper

  def exclude_config_var(var_name)
    excluded_vars = [ "SECRET",
                      "ID_RSA",
                      "AWS_S3_BUCKET_NAME",
                      "API_KEY",
                      "KEY_ID",
                      "LICENSE_KEY",
                      "API_TOKEN",
                      "PASSWORD"
                    ]

    regex = /#{excluded_vars.join("|")}/

    regex.match(var_name)
  end

  def allow_deletion
    ["john.lucia@getg5.com"].include?(current_user.email)
  end

  def count_str(value)
    "<i>#{value.size} apps</i>"
  end

  def regular_app_groups
    [ 'g5-analytics', 'g5-backups', 'g5-cau', 'g5-client', 'g5-cls', 'g5-clw', 'g5-cms-',
      'g5-cpas', 'g5-cpns', 'g5-cxm', 'g5-dsh', 'g5-inventory', 'g5-inv-', 'g5-jobs', 'g5-layout',
      'g5-nae', 'g5-social', 'g5-theme-', 'g5-vendor', 'g5-vls', 'g5-widget', 'g5-app-wrangler']
  end

  def dyno_count(dynos)
    dyno_count = 0
    dynos.each do |dyno|
      dyno_count += dyno["quantity"]
    end
    dyno_count
  end

  def average_dynos_per_app(apps)
    grand_total = 0
    apps.each do |app|
      if app.dynos
        app.dynos.each do |dyno|
          grand_total += dyno["quantity"]
        end
      end 
    end
    average = grand_total.to_f/apps.count
    average.round(1)
  end

  def versioned_apps
    AppVersions.version_apps_list
  end

  def get_mv(type)
    AppVersions.get_master_version(type)
  end
end
