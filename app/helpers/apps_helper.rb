module AppsHelper
  def get_app_groups(apps)
    reg_array = regular_app_groups
    kook_apps = reg_array.join("|")
    grouped = {}
    misfits = {}
    misc_app = []
    misc_app = apps.reject { |app| app.name[/#{kook_apps}/] }
    misfits["MISFITS"] = misc_app
    reg_array.each do |reg|
      app_name = reg.gsub('-', ' ').upcase.gsub('G5', '')
      app_group = apps.select { |app| app.name[/#{reg}/] }
      grouped[app_name] = app_group
    end
    grouped.merge!(misfits)
  end
end