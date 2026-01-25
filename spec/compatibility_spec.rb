require 'json'

RSpec.describe ShinyJsonLogic do
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
          end
        end
      end
    end
  end
end
