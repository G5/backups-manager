class App < ActiveRecord::Base
  belongs_to :organization

  validates :name, :organization, presence: true
  scope :backed_up, -> { where("backup_transfer_success IS TRUE") }
  scope :not_backed_up, -> { where("backup_transfer_success IS FALSE") }
  scope :no_schedules, -> { where("backup_schedule IS NULL") }

  ADDON_FINDERER_SQL = <<-EOS
    SELECT *
    FROM apps a, json_array_elements(a.addons) obj
    WHERE obj#>>'{addon_service,name}' = ?
    AND obj#>>'{plan,name}' = ?;
  EOS

  def type
    App.type_from_name(name)
  end

  def prefix
    App.prefix_from_name(name)
  end

  def self.prefixes
    [ 'g5-nae', 'g5-hub', 'g5-analytics-dashboard', 'g5-backups-manager', 'g5-social-feed-service',
      'g5-phone-number-service', 'g5-news-and-events-service']
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

  def self.group_by_type(apps)
    main_apps, misc_apps = apps.partition(&:prefix)
    main_apps
      .group_by(&:type)
      .merge({ "misc" => misc_apps })
      .sort.to_h
  end

  def has_ssl_addon?
    addons.any? do |h|
      h["addon_service"]["name"] == "ssl" && h["plan"]["name"] == "ssl:endpoint"
    end unless addons.nil?
  end

  def database_plans
    return [] if addons.nil?
    addons.
      select { |h| h["addon_service"]["name"] == "heroku-postgresql" }.
      map { |h| h["plan"]["name"].split(":").last }
  end

  def self.all_with_addon(addon_service_name, plan_name)
    App.find_by_sql([ ADDON_FINDERER_SQL, addon_service_name, plan_name ])
  end
end
