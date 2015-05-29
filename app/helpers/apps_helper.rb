module AppsHelper
  def make_app_array
    app_array = [] 
      @data.each do |key, value| 
        app_array << "#{key['name']}" 
      end
    ordered = get_app_groups(app_array) 
  end

  def get_app_groups(apps)
    reg_array = ['g5-analytics', 'g5-backups', 'g5-cau', 'g5-client', 'g5-cls', 'g5-clw', 'g5-cms-', 'g5-cpas', 'g5-cpns', 'g5-cxm', 'g5-dsh', 'g5-inventory', 'g5-inv-', 'g5-jobs', 'g5-layout', 'g5-nae', 'g5-social', 'g5-theme-', 'g5-vendor', 'g5-vls', 'g5-widget']
    kook_apps = reg_array.join("|")
    grouped = {}
    misfits = {}
    misc_app = []
    misc_app = apps.reject { |i| i[/#{kook_apps}/] }
    misfits["MISFITS"] = misc_app
    reg_array.each do |reg|
      app_name = reg.gsub('-', '').upcase.gsub('G5', '')
      app_group = apps.select { |i| i[/#{reg}/] }
      grouped[app_name] = app_group
    end
    grouped.merge!(misfits)
  end

  def render_app_groups(order_up)
    markup = ""
    order_up.each do |key, value|
      master_version = get_master_version(key.downcase)
      master_version_str = master_version ? "<span class='version'>MASTER: <span class='version-value'>#{master_version}</span></span>" : ""
      markup << "<a name='#{key.downcase.parameterize}'></a>"
      markup << "<h3 class='app-title' id='#{key.downcase.parameterize}'>#{key}#{master_version_str}</h3>" unless value.blank?
      markup << "<ul class='app-list'>" unless value.blank?
      value.each do |v|
        version = "<span class='version'>...</span>" if version_apps_list.has_key?(key.downcase)
        markup << "<li>#{link_to v, app_path(v)}#{version}</li>"
      end
      markup << "</ul>" unless value.blank?
      markup << "<hr />" unless value.blank?
    end
    markup.html_safe
  end

  def version_apps_list
    {
      'cms' => "https://raw.githubusercontent.com/g5search/g5-content-management-system/698f5501689dcf418c6ef4e0071402211840f492/config/version.yml",
      'dsh' => "https://raw.githubusercontent.com/g5search/g5-dashboard/71fda2272aa1db044243e86e900be22c823b6a89/config/version.yml?token=AFfFnCS-HcKWaDeW9lOlYccIdTQ4WIfOks5VcelCwA%3D%3D"
    }
  end

  def get_master_version(app)
    uri = URI(version_apps_list[app]) if version_apps_list.has_key?(app)
    content = Net::HTTP.get(uri) if uri
    yml = YAML.load(content).with_indifferent_access if content
    yml.try(:[], :version) if yml
  end
end