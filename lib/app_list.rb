class AppList
  require "net/http"
  require 'net/https'
  require "uri"

  @@masters = nil

  def initialize
    @uri = "https://api.heroku.com/apps"
    @headers = { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
                 accept: "application/vnd.heroku+json; version=3",
                 range: "name ..; max=1000;"
               }
  end

  def data
    return @data unless @data.blank?

    response = RestClient.get @uri, @headers

    d = JSON.parse response.body

    # Heroku returns up to 1000 records at a time. A response code 
    # of 206 means we only got a subset, so go back for more data.
    while response.code == 206
      @headers[:range] = response.headers[:next_range]
      response = RestClient.get @uri, @headers
      next_batch = JSON.parse response.body
      d += next_batch
    end

    @data = d
  end

  def make_app_array
    return @app_array unless @app_array.blank?
    app_array = []
      data.each do |key, value| 
        app_array << "#{key['name']}" 
      end
    @app_array = get_app_groups(app_array) 
  end

  def get_app_groups(apps)
    reg_array = self.class.regular_app_groups
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

  def self.version_apps_list
    {
      'cms' => "https://raw.githubusercontent.com/g5search/g5-content-management-system/master/config/version.yml",
      'dsh' => "https://raw.githubusercontent.com/g5search/g5-dashboard/master/config/version.yml?token=AFfFnAGZ3yANo_-lbi2Bb8h8kfedepSYks5Vf0XGwA%3D%3D"
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

  def self.regular_app_groups
    [ 'g5-analytics', 'g5-backups', 'g5-cau', 'g5-client', 'g5-cls', 'g5-clw', 'g5-cms-',
      'g5-cpas', 'g5-cpns', 'g5-cxm', 'g5-dsh', 'g5-inventory', 'g5-inv-', 'g5-jobs', 'g5-layout',
      'g5-nae', 'g5-social', 'g5-theme-', 'g5-vendor', 'g5-vls', 'g5-widget']
  end

  def self.get_master_version(app)
    uri = URI(self.version_apps_list[app]) if self.version_apps_list.has_key?(app)
    content = Net::HTTP.get(uri) if uri
    yml = YAML.load(content).try(:with_indifferent_access) if content && content != 'Not Found'
    yml.try(:[], :version) if yml
  end
end