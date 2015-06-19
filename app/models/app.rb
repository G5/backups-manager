class App < ActiveRecord::Base
  @@masters = nil

  def self.version_apps_list
    {
      'cls' => "https://raw.githubusercontent.com/g5search/g5-client-leads-service/master/config/version.yml?token=#{ENV['CLS_GITHUB_TOKEN']}",
      'cms' => "https://raw.githubusercontent.com/g5search/g5-content-management-system/master/config/version.yml",
      'dsh' => "https://raw.githubusercontent.com/g5search/g5-dashboard/master/config/version.yml?token=#{ENV['DSH_GITHUB_TOKEN']}"
    }
  end

  def self.master_versions
    @@masters ||= self.verion_apps_list.inject({}) do |h, (k, v)|
      h[k] = self.get_master_version(k)
      h
    end
  end

  def self.get_master_version(key)
    self.master_versions.try(:[], key.downcase.parameterize)
  end

  def self.get_master_version(app)
    uri = URI(self.version_apps_list[app]) if self.version_apps_list.has_key?(app)
    content = Net::HTTP.get(uri) if uri
    yml = YAML.load(content).try(:with_indifferent_access) if content && content != 'Not Found'
    yml.try(:[], :version) if yml
  end
end