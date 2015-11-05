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
    puts "\n\n\n\n*****\n  Start deploy: #{app} \n*****\n\n\n\n"
    heroku_build_endpoint = "https://api.heroku.com/apps/#{app}/builds"
    system "curl -n -X POST \"#{heroku_build_endpoint}\" \
            -d '{\"source_blob\":{\"url\":\"#{source_url}\"}}' \
            -H 'Accept: application/vnd.heroku+json; version=3' \
            -H \"Content-Type: application/json\" \
            -H \"Authorization: Bearer #{ENV['HEROKU_AUTH_TOKEN']}\""
    puts "\n\n\n\n*****\n  End deploy \n*****\n\n\n\n"
  end



  private

  # Set up public GET and PUT urls on S3 to store the tar.gz we downloaded from Github
  # Note: Both these URL's expire in one hour.
  def generate_sources_endpoints
    puts "\n\n\n\n*****\n  Start generate_sources_endpoints \n*****\n\n\n\n"
    response = HTTPClient.post @heroku_app_sources_endpoint, nil, HerokuApiHelpers.default_headers
    data = JSON.parse response.body
    @heroku_get_url = data["source_blob"]["get_url"]
    @heroku_put_url = data["source_blob"]["put_url"]
    puts "\n\n\n\n*****\n  End generate_sources_endpoints \n*****\n\n\n\n"
  end

  # Download tar.gz from Github
  def download_from_gihub
    puts "\n\n\n\n*****\n  Start download_from_gihub \n*****\n\n\n\n"
    system("curl -H 'Authorization: token #{ENV['GITHUB_TOKEN']}' -L #{@github_file_location} > #{@local_file_location}")
    puts "\n\n\n\n*****\n  Start download_from_gihub \n*****\n\n\n\n"
  end

  # Upload tar.gz to S3
  def upload_to_heroku
    puts "\n\n\n\n*****\n  Start upload_to_heroku \n*****\n\n\n\n"
    system("curl \"#{@heroku_put_url}\" -X PUT -H 'Content-Type:' --data-binary @#{@local_file_location}")
    puts "\n\n\n\n*****\n  Start upload_to_heroku \n*****\n\n\n\n"
  end
end