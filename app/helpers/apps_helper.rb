module AppsHelper
  @@masters = nil

  def get_app_groups(apps)
    reg_array = regular_app_groups
    kook_apps = reg_array.join("|")
    grouped = {}
    misfits = {}
    misc_app = []
    misc_app = apps.reject { |app| app.app_name[/#{kook_apps}/] }
    misfits["MISFITS"] = misc_app
    reg_array.each do |reg|
      app_name = reg.gsub('-', '').upcase.gsub('G5', '')
      app_group = apps.select { |app| app.app_name[/#{reg}/] }
      grouped[app_name] = app_group
    end
    grouped.merge!(misfits)
  end

  def master_versions
    @@masters ||= version_apps_list.inject({}) do |h, (k, v)|
      h[k] = get_app_master_version(k)
      h
    end
  end

  def get_master_version(key)
    master_versions.try(:[], key.downcase.parameterize)
  end

  def get_app_master_version(type)
    uri = URI(version_apps_list[get_app_version_type(type)]) if version_apps_list.has_key?(get_app_version_type(type))
    content = Net::HTTP.get(uri) if uri
    yml = YAML.load(content).try(:with_indifferent_access) if content && content != 'Not Found'
    yml.try(:[], :version) if yml
  end

  def get_app_version_type(app)
    version_list = version_apps_list
    arr = version_list.map do |k, v|
      k if app == k
    end.compact
    arr.empty? ? nil : arr.first
  end

  def regular_app_groups
    [ 'g5-analytics', 'g5-backups', 'g5-cau', 'g5-client', 'g5-cls', 'g5-clw', 'g5-cms-',
      'g5-cpas', 'g5-cpns', 'g5-cxm', 'g5-dsh', 'g5-inventory', 'g5-inv-', 'g5-jobs', 'g5-layout',
      'g5-nae', 'g5-social', 'g5-theme-', 'g5-vendor', 'g5-vls', 'g5-widget']
  end

  def version_apps_list
    {
      'cau' => "https://raw.githubusercontent.com/G5/g5-sibling-deployer/master/config/version.yml",
      'cls' => "https://raw.githubusercontent.com/g5search/g5-client-leads-service/master/config/version.yml?token=#{ENV['CLS_GITHUB_TOKEN']}",
      'cms' => "https://raw.githubusercontent.com/g5search/g5-content-management-system/master/config/version.yml",
      'dsh' => "https://raw.githubusercontent.com/g5search/g5-dashboard/master/config/version.yml?token=#{ENV['DSH_GITHUB_TOKEN']}"
    }
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
      app.dynos.each do |dyno|
        grand_total += dyno["quantity"]
      end
    end
    average = grand_total.to_f/apps.count
    average.round(1)
  end
end