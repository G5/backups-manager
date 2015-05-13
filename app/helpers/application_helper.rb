module ApplicationHelper
  def exclude_config_var(var_name)
    excluded_vars = [ "SECRET",
                      "ID_RSA",
                      "AWS_S3_BUCKET_NAME",
                      "API_KEY",
                      "KEY_ID",
                      "LICENSE_KEY",
                      "API_TOKEN"
                    ]

    regex = /#{excluded_vars.join("|")}/

    regex.match(var_name)
  end
end
