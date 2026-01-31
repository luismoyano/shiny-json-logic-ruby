require 'json'
require "shiny_json_logic/errors/base"

RSpec.describe ShinyJsonLogic do
  describe "standard behavior" do
    [
      {
        "description" => "Coalesce an error",
        "rule" => { "try" => [{ "throw" => "Some error" }, 1] },
        "result" => 1,
        "data" => nil
      },
      {
        "description" => "Coalesce an error emitted from an operator",
        "rule" => { "try" => [{ "/" => [0, 0]}, 1] },
        "result" => 1,
        "data" => { "hello" => "world" }
      },
      {
        "description" => "Try is variadic",
        "rule" => { "try" => [{ "throw" => "Some error" }, { "/" => [0, 0] }, 2] },
        "result" => 2,
        "data" => nil
      },
      {
        "description" => "Panics if none of the values are valid",
        "rule" => { "try" => [{ "throw" => "Some error" }, { "throw" => "Some other error" }] },
        "error" => { "type" => "Some other error" },
        "data" => nil
      },
      {
        "description" => "Panics if none of the values are valid (2)",
        "rule" => { "try" => [{ "throw" => "Some error" }, { "/" => [0, 0] }] },
        "error" => { "type" => "NaN" },
        "data" => nil
      },
      {
        "description" => "Panics if none of the values are valid (3)",
        "rule" => { "try" => [{ "/" => [0, 0] }, { "/" => [1, 0] }, { "/" => [2, 0] }] },
        "error" => { "type" => "NaN" },
        "data" => nil
      },
      {
        "description" => "Panics when the only argument is an error",
        "rule" => { "try" => { "throw" => "Some error" } },
        "error" => { "type" => "Some error" },
        "data" => nil
      },
      {
        "description" => "Panic with an error emitted from an operator",
        "rule" => { "try" => [{ "/" => [1, 0] }] },
        "error" => { "type" => "NaN" },
        "data" => nil
      },
      {
        "description" => "Panic within an iterator",
        "rule" => { "map" => [[1, 2, 3], { "try" => [{ "/" => [0,0] }] }] },
        "error" => { "type" => "NaN" },
        "data" => nil
      },
      {
        "description" => "Panic based on an error emitted from an if",
        "rule" => { "try" => [{ "if" => [{"val" => ["user", "admin"]}, true, { "throw" => "Not an admin" }] }] },
        "data" => { "user" => { "admin" => false } },
        "error" => { "type" => "Not an admin" }
      },
      {
        "description" => "Try can work further up the AST with Exceptions",
        "rule" => {
          "try" => [{
                    "if" => [
                      true,
                      { "map" => [[1,2,3], {"/" => [0, 0] }]},
                      nil
                    ]
                  }, 10]
        },
        "result" => 10,
        "data" => nil
      },
      {
        "description" => "The context switches for the try coalescing to the previous error",
        "rule" => {
          "try" => [
            { "throw" => "Some error" },
            { "val" => "type" }
          ]
        },
        "result" => "Some error",
        "data" => nil
      },
      {
        "description" => "The context switches for the try coalescing to the previous error (2)",
        "rule" => {
          "try" => [
            { "if" => [true, { "throw" => "Some error" }, nil] },
            { "val" => "type" }
          ]
        },
        "result" => "Some error",
        "data" => nil
      },
      {
        "description" => "The context switches for the try coalescing to the previous error (3)",
        "rule" => {
          "try" => [
            { "throw" => "A" },
            { "throw" => "B" },
            { "val" => "type" }
          ]
        },
        "result" => "B",
        "data" => nil
      },
      {
        "description" => "Error can pull from an error object",
        "rule" => {
          "try" => [{ "throw" => { "val" => "x" } }, { "val" => "type" }]
        },
        "data" => { "x" => { "type" => "Some error" }},
        "result" => "Some error"
      },
      {
        "description" => "Try can work further up the AST with Exceptions, and return the error",
        "rule" => {
          "try" => [{
                    "if" => [
                      true,
                      { "map" => [[1,2,3], {"/" => [0, 0] }]},
                      nil
                    ]
                  }, { "val" => "type" }]
        },
        "result" => "NaN",
        "data" => nil
      },
      {
        "description" => "Handles NaN Explicitly",
        "rule" => {
          "try" => [
            { "if" => [{ "/" => [1, { "val" => "x" }] }, { "throw" => "Some error" }, nil] },
            {
              "if" => [{ "===" => [{ "val" => "type" }, "NaN"]}, "Handled", { "throw" => { "val" => [] } }]
            }
          ]
        },
        "result" => "Handled",
        "data" => { "x" => 0 }
      },
      {
        "description" => "Did not NaN, so it errored",
        "rule" => {
          "try" => [
            { "if" => [{ "/" => [1, { "val" => "x" }] }, { "throw" => "Some error" }, nil] },
            { "if" => [{ "===" => [{ "val" => "type" }, "NaN"]}, "Handled", { "throw" => { "val" => [] } }] }
          ]
        },
        "error" => { "type" => "Some error" },
        "data" => { "x" => 1 }
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
