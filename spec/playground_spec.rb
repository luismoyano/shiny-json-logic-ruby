require 'json'
require "shiny_json_logic/errors/base"

RSpec.describe ShinyJsonLogic do
  describe "standard behavior" do
    [
      {
        "description" => "> is lazily evaluated",
        "rule" => { ">" => [2, 3, { "throw" => "Not Lazy" }] },
        "data" => {},
        "result" => false
      }
    ].each_with_index do |testcase, index|
      next unless testcase.is_a?(Hash)

      describe "example ##{index}: #{testcase["description"]}" do
        it "works" do
          expect(described_class.apply(testcase["rule"], testcase["data"])).to eq(testcase["result"])
        rescue ShinyJsonLogic::Errors::Base => e
          expect(testcase["error"]).to eq(e.payload)
        end
      end
    end
  end
end
