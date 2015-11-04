class CmsTarBall

  def initialize(app_name, branch_name = 'master')
    @branch_name = branch_name
    @github_file_location = "https://api.github.com/repos/g5search/g5-content-management-system/tarball/#{branch_name}"
    @local_file_location = "#{Rails.root.to_s}/tmp/#{@branch_name}.tar.gz"
    @heroku_app_sources_endpoint = "https://api.heroku.com/apps/#{app_name}/sources"
    @heroku_build_endpoint = "https://api.heroku.com/apps/#{app_name}/builds"
    generate_sources_endpoints
  end

  def deploy_to_heroku
    download
    upload
    deploy_cms
  end

  private

  def generate_sources_endpoints
    response = HTTPClient.post @heroku_app_sources_endpoint, nil, HerokuApiHelpers.default_headers
    data = JSON.parse response.body
    @heroku_get_url = data["source_blob"]["get_url"]
    @heroku_put_url = data["source_blob"]["put_url"]
  end

  def download
    system("curl -H 'Authorization: token #{ENV['GITHUB_TOKEN']}' -L #{@github_file_location} > #{@local_file_location}")
  end

  def upload
    system("curl \"#{@heroku_put_url}\" -X PUT -H 'Content-Type:' --data-binary @#{@local_file_location}")
  end

  def deploy_cms
    system "curl -n -X POST \"#{@heroku_build_endpoint}\" \
            -d '{\"source_blob\":{\"url\":\"#{@heroku_get_url}\"}}' \
            -H 'Accept: application/vnd.heroku+json; version=3' \
            -H \"Content-Type: application/json\""


    # -d '{\"source_blob\":{\"url\":\"#{@heroku_get_url}\", \"version\": \"@branch_name\"}}' \
  end
end