require 'json'
require "shiny_json_logic/errors/base"

RSpec.describe JsonLogic do
  root = ENV.fetch("COMPAT_SUITES_DIR", File.expand_path("./fixtures/", __dir__))
  paths = Dir.glob(File.join(root, "**/*.json")).sort

  describe "standard behavior" do
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
