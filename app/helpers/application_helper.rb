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
      'g5-nae', 'g5-social', 'g5-theme-', 'g5-vendor', 'g5-widget', 'g5-app-wrangler', 'g5-hub', 'g5-integrations', 'g5-phone-number-service', 'g5-configurator', 'g5-news-and-events-service']
  end

  def dyno_count(dynos)
    dyno_count = 0
    if dynos.present?
      dynos.each do |dyno|
        dyno_count += dyno["quantity"] if dyno.class == Hash
      end
    end
    dyno_count
  end

  def free_dynos?(dynos)
    if dynos.present?
      true if dynos.any? {|dyno| (dyno["quantity"] > 0 && dyno["size"] == "Free") if dyno.class == Hash}
    end
  end

  def average_dynos_per_app(apps)
    grand_total = 0
    apps.each do |app|
      if app.dynos
        app.dynos.each do |dyno|
          grand_total += dyno["quantity"] if dyno.class == Hash
        end
      end 
    end
    average = grand_total.to_f/apps.count
    average.round(1)
  end

  def get_mv(type)
    AppVersions.master_versions[type]
  end

  def current_time(format)
    zone = ActiveSupport::TimeZone.new("Pacific Time (US & Canada)")
    Time.now.in_time_zone(zone).strftime(format)
  end
end
