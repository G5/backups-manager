require 'rails_helper'

RSpec.describe CmsController, type: :controller, auth_controller: true do
  before { allow(RateCheck).to receive(:usage).and_return(2300) }

  context "with a mix of app types" do
    let(:cms) { FactoryGirl.create(:app, name: "g5-cms-1234") }
    before { FactoryGirl.create(:app, name: "g5-cau-1234") }

    it "assigns CMS apps only" do
      get :index
      expect(assigns(:cms_list)).to eq([cms])
    end
  end
end
