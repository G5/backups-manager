require 'rails_helper'

describe LiveSummariesController do
  describe 'GET index', auth_controller: true do
    let(:dynos) { stub_app_dynos_response }
    let!(:selected_app) { Fabricate(:complete_app) }

    before do
      stub_request(:get, "https://la.team%40getg5.com:#{ENV['HEROKU_AUTH_TOKEN']}@api.heroku.com/apps/#{selected_app.app_details["name"]}/formation").to_return(:status => 200, :body => dynos.to_json, :headers => {})

      get :index, app_id: selected_app.id
    end

    it "finds the correct app" do
      expect(assigns(:app).id).to eq(selected_app.id)
    end

    it "retrieves the dynos for the cooresponding app" do
      expect(assigns(:app_dynos)).to eq(dynos)
    end
  end
end
