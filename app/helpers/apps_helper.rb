module AppsHelper
  def get_app_groups(apps)
    reg_array = ['g5-cms-',  'g5-cpns', 'g5-inventory', 'g5-inv-', 'g5-jobs', 'g5-layout', 'g5-nae', 'g5-social', 'g5-theme-', 'g5-vendor', 'g5-vls', 'g5-widget']
    kook_apps = reg_array.join("|")
    grouped = {}
    misfits = {}
    misc_app = []
    misc_app = apps.reject { |i| i[/#{kook_apps}/] }
    misfits["MISFITS"] = misc_app
    #binding.pry
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
      markup << "<h3 class='app-title'>#{key}</h3>" unless value.blank?
      value.each do |v|
        markup << "<p><a href=''>#{v}</a></p>"
      end
    end
    markup.html_safe
  end
end
