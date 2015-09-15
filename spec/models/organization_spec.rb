describe Organization do
  describe "#name" do
    it "strips out the email addressy bits" do
      app = Organization.new(email: "test@herokumanager.com")
      expect(app.name).to eq("test")
    end
  end
end
