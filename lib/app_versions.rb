class AppVersions
  @@masters
  def self.master_version_inputs
    version_apps_list.inject("") do |str, (key, value)|
      master_version = get_master_version(key)
      str << "<input type='hidden' id='master-version-#{key}' value='#{master_version}'>"
      str
    end.html_safe
  end

  def self.master_versions
    @@masters ||= version_apps_list.inject({}) do |h, (k, v)|
      h[k] = get_app_master_version(k)
      h
    end
  end

  def self.get_master_version(key)
    master_versions.try(:[], key.downcase.parameterize)
  end

  def self.get_app_master_version(type)
    uri = URI(version_apps_list[get_app_version_type(type)]) if version_apps_list.has_key?(get_app_version_type(type))
    content = Net::HTTP.get(uri) if uri
    yml = YAML.load(content).try(:with_indifferent_access) if content && content != 'Not Found'
    yml.try(:[], :version) if yml
  end

  def self.get_app_version_type(app)
    version_list = version_apps_list
    arr = version_list.map do |k, v|
      k if app == k
    end.compact
    arr.empty? ? nil : arr.first
  end

  def self.version_apps_list
    {
      'cau' => "https://raw.githubusercontent.com/G5/g5-sibling-deployer/master/config/version.yml",
      'cls' => "https://raw.githubusercontent.com/g5search/g5-client-leads-service/master/config/version.yml?token=#{ENV['CLS_GITHUB_TOKEN']}",
      'cms' => "https://raw.githubusercontent.com/g5search/g5-content-management-system/master/config/version.yml",
      'dsh' => "https://raw.githubusercontent.com/g5search/g5-dashboard/master/config/version.yml?token=#{ENV['DSH_GITHUB_TOKEN']}"
    }
  end

  def self.app_list
    { 'cau' => "G5/g5-sibling-deployer",
      'cls' => "g5search/g5-client-leads-service",
      'cms' => "g5search/g5-content-management-system",
      'dsh' => "g5search/g5-dashboard" }
  end

  def self.is_versioned?(type)
    app_list.has_key?(type)
  end
end
