require 'rails_helper'

describe App do
  describe ".type_from_name" do
    it "finds app types in hyphenated names" do
      allow(AppVersions).to receive(:app_list)
        .and_return({ 'cau' => "_",  #only key names are relevant here
                      'cls' => "_",
                      'cms' => "_",
                      'dsh' => "_" })

      # Limitation: only supports versioned apps at this time (those in above hash)

      inputs = ["g5-cms-somestuff",
                "anyotherstuff-cls",
                "not-an-app-to-be-found",
                "badcms-hyphens",
                "", nil,
                "cms-cls-cau-and-dsh"]

      expected = ["cms", "cls", "", "", "", "", ""]

      expect(inputs.map {|i| App.type_from_name(i)}).to eq(expected)
    end
  end
end
