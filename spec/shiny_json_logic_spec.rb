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

  describe "indifferent access with symbol keys" do
    # These tests use Ruby symbols which can't be represented in JSON
    # so they remain as RSpec tests

    describe "data with symbol keys" do
      let(:data) { { name: "Jane", age: 25, items: [4, 5, 6] } }

      it "accesses data with var operator" do
        expect(described_class.apply({ "var" => "name" }, data)).to eq("Jane")
      end

      it "accesses data with val operator" do
        expect(described_class.apply({ "val" => "age" }, data)).to eq(25)
      end

      it "works with missing operator" do
        expect(described_class.apply({ "missing" => ["name", "address"] }, data)).to eq(["address"])
      end

      it "works with missing_some operator" do
        expect(described_class.apply({ "missing_some" => [1, ["name", "address"]] }, data)).to eq([])
      end

      it "works with iterators" do
        expect(described_class.apply({ "map" => [{ "var" => "items" }, { "*" => [{ "var" => "" }, 2] }] }, data)).to eq([8, 10, 12])
      end
    end

    describe "data with mixed keys" do
      let(:data) { { "name" => "Bob", age: 35, items: [7, 8, 9] } }

      it "accesses string key" do
        expect(described_class.apply({ "var" => "name" }, data)).to eq("Bob")
      end

      it "accesses symbol key" do
        expect(described_class.apply({ "var" => "age" }, data)).to eq(35)
      end

      it "accesses symbol key array" do
        expect(described_class.apply({ "var" => "items" }, data)).to eq([7, 8, 9])
      end
    end

    describe "nested data with symbol keys" do
      let(:data) { { person: { name: "Alice", details: { age: 28 } } } }

      it "accesses deeply nested data with var" do
        expect(described_class.apply({ "var" => "person.name" }, data)).to eq("Alice")
        expect(described_class.apply({ "var" => "person.details.age" }, data)).to eq(28)
      end

      it "accesses deeply nested data with val" do
        expect(described_class.apply({ "val" => ["person", "name"] }, data)).to eq("Alice")
        expect(described_class.apply({ "val" => ["person", "details", "age"] }, data)).to eq(28)
      end
    end

    describe "rules with string keys" do
      let(:data) { { "x" => 10, "y" => 20 } }

      it "evaluates simple rule" do
        expect(described_class.apply({ "var" => "x" }, data)).to eq(10)
      end

      it "evaluates nested rules" do
        expect(described_class.apply({ "+" => [{ "var" => "x" }, { "var" => "y" }] }, data)).to eq(30)
      end

      it "evaluates if rule" do
        expect(described_class.apply({ "if" => [{ ">" => [{ "var" => "x" }, 5] }, "big", "small"] }, data)).to eq("big")
      end
    end

    describe "rules with symbol keys" do
      let(:data) { { "x" => 10, "y" => 20 } }

      it "evaluates simple rule" do
        expect(described_class.apply({ var: "x" }, data)).to eq(10)
      end

      it "evaluates nested rules" do
        expect(described_class.apply({ "+": [{ var: "x" }, { var: "y" }] }, data)).to eq(30)
      end

      it "evaluates if rule" do
        expect(described_class.apply({ if: [{ ">": [{ var: "x" }, 5] }, "big", "small"] }, data)).to eq("big")
      end
    end

    describe "rules with mixed keys" do
      let(:data) { { "x" => 10, "y" => 20 } }

      it "evaluates mixed string and symbol operators" do
        expect(described_class.apply({ "+" => [{ var: "x" }, { "var" => "y" }] }, data)).to eq(30)
      end

      it "evaluates nested mixed rules" do
        expect(described_class.apply({ if: [{ ">" => [{ var: "x" }, 5] }, "big", "small"] }, data)).to eq("big")
      end
    end

    describe "both rules and data with symbols" do
      let(:data) { { name: "Alice", age: 28 } }

      it "accesses symbol data with symbol rule" do
        expect(described_class.apply({ var: "name" }, data)).to eq("Alice")
      end

      it "evaluates complex nested structure" do
        rule = { if: [{ ">=": [{ var: "age" }, 18] }, "adult", "minor"] }
        expect(described_class.apply(rule, data)).to eq("adult")
      end

      it "works with val and symbol keys" do
        expect(described_class.apply({ val: :name }, data)).to eq("Alice")
      end
    end

    describe "does not mutate original data" do
      it "preserves original hash with string keys" do
        data = { "name" => "Test" }
        original = data.dup
        described_class.apply({ "var" => "name" }, data)
        expect(data).to eq(original)
      end

      it "preserves original hash with symbol keys" do
        data = { name: "Test" }
        original = data.dup
        described_class.apply({ "var" => "name" }, data)
        expect(data).to eq(original)
      end
    end
  end

  describe "shiny tests (from JSON)" do
    json_path = File.join(__dir__, "fixtures", "shiny_tests.json")
    testcases = JSON.parse(File.read(json_path))

    testcases.each do |testcase|
      next if testcase.is_a?(String) # Skip comment strings

      description = testcase["description"]

      it description do
        if testcase.key?("error")
          expect {
            described_class.apply(testcase["rule"], testcase["data"])
          }.to raise_error(ShinyJsonLogic::Errors::Base) do |error|
            expect(error.type).to eq(testcase["error"]["type"])
          end
        else
          result = described_class.apply(testcase["rule"], testcase["data"])
          expect(result).to eq(testcase["result"])
        end
      end
    end
  end
end
