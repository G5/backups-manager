module AppsHelper
  @@masters = nil

  def render_app_groups(apps)
    markup = ""
    grouped_apps = get_app_groups(apps)
    grouped_apps.each do |group|
      master_version = get_master_version("group")
      master_version_str = master_version ? "<span class='version'>MASTER: <span class='version-value'>#{master_version}</span></span>" : ""
      markup << apps_title_str(group, group[1].count, master_version_str)
      markup << "<ul class='app-list'>" unless group[1].blank?
      group[1].each do |app|
        markup << app_item_str(app.app_name, app)
      end
      markup << "</ul>" unless group[1].blank?
    end
    markup.html_safe
  end

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

  def apps_title_str(group, value, master_version_str="")
    refresh = "<a href='#' class='version-refresh'>#{image_tag('reload.png', class: 'version-refresh-icon', alt: 'Refresh Versions')}</a>" unless master_version_str.blank?
    "<h3 class='app-title' id='#{key_slug(group[0])}'><span class='app-name'>#{group}</span>#{count_str(value)}#{master_version_str}#{refresh}</h3>"
  end

  def app_version_str(key)
    "<span class='version'><span class='version-value'>...</span></span>" if version_apps_list.has_key?(key)
  end

  def app_item_str(appname, app)
    "<li>#{app_link_str(app)}#{heroku_dashboard_link_str(app)}#{heroku_app_link_str(app)}#{app_version_str(key_slug(appname))}</li>"
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
      'cls' => "https://raw.githubusercontent.com/g5search/g5-client-leads-service/master/config/version.yml?token=#{ENV['CLS_GITHUB_TOKEN']}",
      'cms' => "https://raw.githubusercontent.com/g5search/g5-content-management-system/master/config/version.yml",
      'dsh' => "https://raw.githubusercontent.com/g5search/g5-dashboard/master/config/version.yml?token=#{ENV['DSH_GITHUB_TOKEN']}"
    }
  end
end