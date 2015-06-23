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

  def key_slug(appname)
    appname.downcase.parameterize if appname
  end

  def heroku_dashboard_link_str(app)
    "<a href='https://dashboard.heroku.com/apps/#{app.app_name}/' target='_blank' class='heroku-dashboard'>Dashboard</a>"
  end

  def heroku_app_link_str(app)
    "<a href='https://#{app.app_name}.herokuapp.com' target='_blank' class='heroku-app'>App</a>"
  end

  def app_link_str(app)
    "<span class='app-name'>" + link_to(app.app_name, app_path(app)) + "</span>"
  end
end
