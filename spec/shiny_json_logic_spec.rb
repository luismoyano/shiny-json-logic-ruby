require 'json'

RSpec.describe ShinyJsonLogic do
  it "has a version number" do
    expect(ShinyJsonLogic::VERSION).not_to be nil
  end

  describe "module aliases" do
    it "JsonLogic is an alias for ShinyJsonLogic" do
      expect(JsonLogic).to eq(ShinyJsonLogic)
    end

    it "JSONLogic is an alias for ShinyJsonLogic" do
      expect(JSONLogic).to eq(ShinyJsonLogic)
    end

    it "JsonLogic.apply works" do
      expect(JsonLogic.apply({ "+" => [1, 2] })).to eq(3)
    end

    it "JSONLogic.apply works" do
      expect(JSONLogic.apply({ "+" => [1, 2] })).to eq(3)
    end
  end
end
