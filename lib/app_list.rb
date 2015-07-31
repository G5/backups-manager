class AppList
  APP_TYPES = [ :cau, :cls, :clw, :cms, :cpas, :cxm, :dsh, :nae, :other ]

  def self.get
    app_list_uri = "https://api.heroku.com/apps"
    headers = default_headers 
    response = HTTPClient.get app_list_uri, nil, headers
    data = JSON.parse response.body
    # Heroku returns up to 1000 records at a time. A response code 
    # of 206 means we only got a subset, so go back for more data.
    while response.code == 206
      headers[:range] = response.headers["Next-Range"].gsub("]", "..")
      response = HTTPClient.get app_list_uri, nil, headers
      next_batch = JSON.parse response.body
      data += next_batch
    end

    data
  end

  def self.sorted
    app_list = self.get
    sorted_apps = {}
    APP_TYPES.each do |app_type|
      sorted_apps[app_type] = []
    end
    app_list.each do |app|
      split_name = app["name"].split("-")
      if split_name.length > 3 && APP_TYPES.include?(split_name[1].to_sym)
        grouping = split_name[1]
      else 
        grouping = "other"
      end
      sorted_apps[grouping.to_sym] << app
    end
    sorted_apps
  end
  
  def self.default_headers
    { authorization: "Bearer #{ENV['HEROKU_AUTH_TOKEN']}",
      accept: "application/vnd.heroku+json; version=3",
      range: "name ..; max=1000;" }
  end
end
