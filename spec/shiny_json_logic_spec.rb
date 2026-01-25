require 'json'

RSpec.describe ShinyJsonLogic do
  cases = JSON.parse(File.read(File.join(File.dirname(__FILE__), 'fixtures/tests.json')))

  it "has a version number" do
    expect(ShinyJsonLogic::VERSION).not_to be nil
  end

  describe "standard behavior" do
    cases.each_with_index do |testcase, index|
      next unless testcase.is_a?(Array)

      describe "example ##{index}: #{testcase}" do
        it "works" do
          expect(described_class.apply(*testcase[0..1])).to eq(testcase.last)
        end
      end
    end
  end
end
