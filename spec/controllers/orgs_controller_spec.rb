require 'spec_helper'

describe OrgsController do
  describe 'GET index', auth_controller: true do
    let!(:app) { Fabricate(:complete_app) }
    before do
      stub_request(:get, "https://la.team%40getg5.com:#{ENV['HEROKU_AUTH_TOKEN']}@api.heroku.com/account/rate-limits").
         with(:headers => {'Accept'=>'application/vnd.heroku+json; version=3', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => {"remaining" => 2400}.to_json, :headers => {})

      get :index
    end

    
  end
end
