require 'json'
require "shiny_json_logic/errors/base"

RSpec.describe ShinyJsonLogic do
  describe "standard behavior" do
    [
      # {
      #   "description" => "Filter even numbers",
      #   "rule" => {
      #     "filter" => [
      #       {"var" => "numbers"},
      #       {"==" => [0, {"%" => [{"var" => ""}, 2]}]}
      #     ]
      #   },
      #   "data" => {"numbers" => [1, 2, 3, 4, 5, 6]},
      #   "result" => [2, 4, 6]
      # },
      # {
      #   "description" => "Filter with nil predicate should throw",
      #   "rule" => {
      #     "filter" => [{"var" => "numbers"}, nil]
      #   },
      #   "data" => {"numbers" => [1, 2, 3]},
      #   "error" => {"type" => "Invalid Arguments"}
      # },
      # {
      #   "description" => "Map with nil mapper should throw",
      #   "rule" => {"map" => [{"var" => "integers"}, nil]},
      #   "data" => {"integers" => [1, 2, 3]},
      #   "error" => {"type" => "Invalid Arguments"}
      # },
      # {
      #   "description" => "Merge with nil should be ignored",
      #   "rule" => {
      #     "merge" => [
      #       [1, 2],
      #       nil,
      #       [3, 4]
      #     ]
      #   },
      #   "data" => nil,
      #   "result" => [1, 2, nil, 3, 4]
      # },
      # {
      #   "description" => "nil predicate returns true",
      #   "rule" => {
      #     "none" => [
      #       {"var" => "numbers"},
      #       nil
      #     ]
      #   },
      #   "data" => {"numbers" => [1, 2, 3]},
      #   "result" => true
      # },
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
