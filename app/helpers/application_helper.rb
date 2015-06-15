module ApplicationHelper
  def exclude_config_var(var_name)
    excluded_vars = [ "SECRET",
                      "ID_RSA",
                      "AWS_S3_BUCKET_NAME",
                      "API_KEY",
                      "KEY_ID",
                      "LICENSE_KEY",
                      "API_TOKEN",
                      "PASSWORD"
                    ]

    regex = /#{excluded_vars.join("|")}/

    regex.match(var_name)
  end

  def allow_deletion
    ["john.lucia@getg5.com"].include?(current_user.email)
  end

  def count_str(value)
    "<i>#{value.size} apps</i>"
  end

  def anchor_str(key)
    "<a name='#{key_slug(key)}'></a>"
  end

  def key_slug(key)
    key.downcase.parameterize if key
  end

  def heroku_dashboard_link_str(appname)
    "<a href='https://dashboard.heroku.com/apps/#{appname}/' target='_blank' class='heroku-dashboard'>Dashboard</a>"
  end

  def heroku_app_link_str(appname)
    "<a href='https://#{appname}.herokuapp.com' target='_blank' class='heroku-app'>App</a>"
  end

  def get_app_version_type(appname)
    arr = AppList.version_apps_list.map do |k, v|
      k if appname.include?("g5-#{k}-")
    end.compact
    arr.empty? ? nil : arr.first
  end

  def app_link_str(appname)
    "<span class='app-name'>" + link_to(appname, app_path(appname)) + "</span>"
  end
end
