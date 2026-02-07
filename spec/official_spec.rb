require 'json'
require "shiny_json_logic/errors/base"

RSpec.describe JsonLogic do
  root = ENV.fetch("OFFICIAL_TESTS_DIR", nil)
  
  # Skip if official tests directory not provided
  next unless root && Dir.exist?(root)

  paths = Dir.glob(File.join(root, "**/*.json")).sort

  describe "official tests (json-logic/.github)" do
    paths.each do |path|
      cases = JSON.parse(File.read(path))
      cases.each_with_index do |testcase, index|
        next unless testcase.is_a?(Hash)

        describe "example ##{index}: #{testcase["description"]}" do
          it "works" do
            expect(described_class.apply(testcase["rule"], testcase["data"])).to eq(testcase["result"])
          rescue JsonLogic::Errors::Base => e
            expect(testcase["error"]).to eq(e.payload)
          end
        end
      end
    end
  end
end
