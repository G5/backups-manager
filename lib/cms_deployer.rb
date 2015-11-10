class CmsDeployer

  def initialize(apps, branch_name = 'master')
    @branch_name = branch_name
    @github_file_location = "https://api.github.com/repos/g5search/g5-content-management-system/tarball/#{branch_name}"
    @local_file_location = "#{Rails.root.to_s}/tmp/#{@branch_name}-#{Time.now.to_i}.tar.gz"
    @heroku_app_sources_endpoint = "https://api.heroku.com/apps/#{apps.first}/sources"
    generate_sources_endpoints
    download_from_gihub
    upload_to_heroku
  end

  def blob_url
    @heroku_get_url
  end

  def self.deploy(source_url, app)
    heroku_build_endpoint = "https://api.heroku.com/apps/#{app}/builds"

    headers = { 'Accept': 'application/vnd.heroku+json; version=3', 
                'Content-Type': 'application/json', 
                'Authorization': "Bearer #{ENV['HEROKU_AUTH_TOKEN']}" }
    data = {source_blob: {url: source_url} }.to_json
    response = HTTPClient.post heroku_build_endpoint, data, headers

    parsed_response = JSON.parse response.body

    build_id = parsed_response['id']
  end

  def self.capture_backup(app)
    `#{self.heroku_command_prefix} pg:backups capture --app #{app}`
  end

  def self.post_deploy_tasks(app)
    `#{self.heroku_command_prefix} run rake db:migrate --app #{app}`
    `#{self.heroku_command_prefix} restart --app #{app}`
    `#{self.heroku_command_prefix} run rake widget:update --app #{app}`
    `#{self.heroku_command_prefix} run rake theme:update --app #{app}`
  end

  def self.build_status(app, build_id)
    # "failed" or "pending" or "succeeded"
    build_status_endpoint = "https://api.heroku.com/apps/#{app}/builds/#{build_id}"
    response = HTTPClient.get build_status_endpoint, nil, HerokuApiHelpers.default_headers
    JSON.parse(response.body)["status"]
  end

  private

  # Set up public GET and PUT urls on S3 to store the tar.gz we downloaded from Github
  # Note: Both these URL's expire in one hour.
  def generate_sources_endpoints
    response = HTTPClient.post @heroku_app_sources_endpoint, nil, HerokuApiHelpers.default_headers
    data = JSON.parse response.body
    @heroku_get_url = data["source_blob"]["get_url"]
    @heroku_put_url = data["source_blob"]["put_url"]
  end

  # Download tar.gz from Github
  def download_from_gihub
    system("curl -H 'Authorization: token #{ENV['GITHUB_TOKEN']}' -L #{@github_file_location} > #{@local_file_location}")
  end

  # Upload tar.gz to S3
  def upload_to_heroku
    system("curl \"#{@heroku_put_url}\" -X PUT -H 'Content-Type:' --data-binary @#{@local_file_location}")
  end

  def self.heroku_command_prefix
    Rails.env.production? ? "vendor/heroku-toolbelt/bin/heroku" : "heroku"
  end
end