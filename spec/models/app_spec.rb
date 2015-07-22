describe App do
  describe "#owner_name" do
    it "returns the portion of owner email before the @ sign" do
      input = [ "foo@foo.com", "bar", "123@word@up.to", "", nil]
      expected = ["foo", "bar", "123", nil, nil]

      actual = input.map do |i|
        app = App.new(app_details: {"owner" => {"email" => i}})
        app.owner_name
      end

      expect(actual).to eq(expected)
    end
  end

  describe ".type_from_name" do
    it "finds app types based on prefixes in app names" do

      # when multiple app types are present, the first is selected
      # app type will be found even if not surrounded by hyphens

      inputs = ["g5-cms-somestuff",
                "anyotherstuff-cls",
                "not-an-app-to-be-found",
                "badcms-hyphens",
                "", nil,
                "cms-cls-cau-and-dsh",
                "g5-nae-thenews"]

      expected = ["cms", "cls", nil, "cms", nil, nil, "cms", "nae"]

      expect(inputs.map {|i| App.type_from_name(i)}).to eq(expected)
    end
  end

  describe ".prefix_from_name" do
    it "finds the standard app prefixes in app names" do

      #prefixes are only found when they are at the beginning

      inputs = ["g5-cms-somestuff",
                "t1-cls-wontwork",
                "g5-widget-garden",
                "bad-g5-cms-hyphens",
                "", nil,
                "g5-cms-cls-cau-and-dsh",
                "g5-nae-thenews"]

      expected = ["g5-cms", nil, "g5-widget-garden", nil, nil, nil, "g5-cms", "g5-nae"]

      expect(inputs.map {|i| App.prefix_from_name(i)}).to eq(expected)
    end
  end

  describe ".group_by_type" do
    it "groups apps keyed by type" do
      names = ["g5-cms-foo", "somejunk-cms", "g5-cms-bar", "g5-cls-word", "g5-cls-bird"]
      apps = names.map { |n| App.new(name: n) }
      grouped = App.group_by_type(apps)

      expect(grouped.keys).to eq(["cls", "cms", "misc"])
      expect(grouped["cms"].count).to eq(2)
      expect(grouped["cls"].count).to eq(2)
      expect(grouped["misc"].first.name).to eq("somejunk-cms")
    end
  end

  describe ".group_by_owner" do
    it "groups apps keyed by email name" do
      emails = ["alpha@foo.com", "beta@foo.com", "alpha@foo.com", "beta@foo.com", "alpha@foo.com"]
      apps = emails.map { |e| App.new(app_details: {"owner" => {"email" => e}}) }
      grouped = App.group_by_owner(apps)

      expect(grouped.keys).to eq(["alpha", "beta"])
      expect(grouped["alpha"].count).to eq(3)
      expect(grouped["beta"].count).to eq(2)
    end
  end
end
