require 'json'

RSpec.describe ShinyJsonLogic do
  it "has a version number" do
    expect(ShinyJsonLogic::VERSION).not_to be nil
  end
end
