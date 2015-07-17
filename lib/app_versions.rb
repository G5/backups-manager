class AppVersions
  def self.app_list
    { 'cau' => "G5/g5-sibling-deployer",
      'cls' => "g5search/g5-client-leads-service",
      'cms' => "g5search/g5-content-management-system",
      'dsh' => "g5search/g5-dashboard" }
  end

  def self.is_versioned?(type)
    app_list.has_key?(type)
  end

  def self.master_versions
    @@masters ||= app_list.keys.each_with_object({}) do |k, h|
      h[k] = fetch_master_version(k)
    end
  end

  def self.master_version_inputs
    app_list.keys.each_with_object("") do |key, str|
      str << "<input type='hidden' id='master-version-#{key}' value='#{master_versions[key]}'>"
    end.html_safe
  end

  private

  def self.fetch_master_version(type)
    return unless is_versioned?(type)
    uri = "https://api.github.com/repos/#{app_list[type]}/contents/config/version.yml?access_token=#{ENV['GITHUB_ACCESS_TOKEN']}"
    res = HTTPClient.get(uri)
    if res.status == 200
      json = JSON.parse(res.content)
      version_file = Base64.decode64(json["content"])
      yaml = YAML.load(version_file)
      yaml["version"]
    end
  end
end
