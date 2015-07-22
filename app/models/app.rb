class App < ActiveRecord::Base
  def type
    App.type_from_name(name)
  end

  def prefix
    App.prefix_from_name(name)
  end

  def owner_name
    app_details["owner"]["email"].split('@').first rescue nil
  end

  def self.prefixes
    [ 'g5-cau', 'g5-cls', 'g5-clw', 'g5-cms', 'g5-cpas', 'g5-cpns', 'g5-cxm', 'g5-dsh', 'g5-inv', 'g5-jobs', 'g5-nae',
      'g5-hub', 'g5-configurator', 'g5-client-app-creator', 'g5-app-wrangler', 'g5-layout-garden', 'g5-theme-garden',
      'g5-widget-garden', 'g5-analytics-dashboard', 'g5-backups-manager', 'g5-inventory', 'g5-social-feed-service',
      'g5-integrations', 'g5-vendor-leads', 'g5-phone-number-service', 'g5-news-and-events-service']
  end

  def self.types
    @@types ||= prefixes.map {|p| p.gsub('g5-', '')}
  end

  def self.type_from_name(name)
    regex_str = types.join("|")
    name.try(:[], /#{regex_str}/)
  end

  def self.prefix_from_name(name)
    # add caret to only match beginning of string
    regex_str = prefixes.map {|p| "^#{p}"}.join("|")
    name.try(:[], /#{regex_str}/)
  end

  def self.group_by_owner(apps)
    apps.group_by(&:owner_name).sort.to_h
  end

  def self.group_by_type(apps)
    main_apps, misc_apps = apps.partition(&:prefix)
    main_apps
      .group_by(&:type)
      .merge({ "misc" => misc_apps })
      .sort.to_h
  end
end
