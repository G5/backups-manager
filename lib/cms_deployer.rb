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
    system "curl -n -X POST \"#{heroku_build_endpoint}\" \
            -d '{\"source_blob\":{\"url\":\"#{source_url}\"}}' \
            -H 'Accept: application/vnd.heroku+json; version=3' \
            -H \"Content-Type: application/json\""
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
end