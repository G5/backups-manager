describe App do
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

  describe "#has_ssl_addon?" do
    subject { app.has_ssl_addon? }

    context "when it actually does" do
      let(:app) { FactoryGirl.build(:ssl_app) }
      it { should be_truthy }
    end

    context "when it doesn't have the addon" do
      let(:app) { FactoryGirl.build(:app) }
      it { should be_falsey }
    end
  end

  describe "#database_plans" do
    subject { app.database_plans }

    context "when no addon metadata exists" do
      let(:app) { App.new }
      it { should be_empty }
    end

    context "when addon metadata contains no database addons" do
      let(:app) { FactoryGirl.build(:app) }
      it { should be_empty }
    end

    context "with associated database plans" do
      let(:app) { FactoryGirl.build(:paid_db_app) }
      it { should eq([ "hobby-basic", "hobby-dev" ]) }
    end
  end
end
