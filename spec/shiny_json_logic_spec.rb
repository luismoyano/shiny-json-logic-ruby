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

    describe "var with dot notation on symbol keys" do
      it "accesses nested sym key via dot notation" do
        data = { user: { name: "Alice" } }
        expect(described_class.apply({ "var" => "user.name" }, data)).to eq("Alice")
      end

      it "accesses 3-level deep sym keys via dot notation" do
        data = { a: { b: { c: 42 } } }
        expect(described_class.apply({ "var" => "a.b.c" }, data)).to eq(42)
      end

      it "accesses mixed sym/str keys at different levels via dot notation" do
        data = { "user" => { name: "Bob", address: { "city" => "Madrid" } } }
        expect(described_class.apply({ "var" => "user.name" }, data)).to eq("Bob")
        expect(described_class.apply({ "var" => "user.address.city" }, data)).to eq("Madrid")
      end

      it "returns nil for missing key at end of dot path with sym parent" do
        data = { user: { name: "Alice" } }
        expect(described_class.apply({ "var" => "user.missing" }, data)).to be_nil
      end

      it "returns default when dot path misses on sym data" do
        data = { user: { name: "Alice" } }
        expect(described_class.apply({ "var" => ["user.missing", "fallback"] }, data)).to eq("fallback")
      end

      it "accesses sym key that is a root-level with sym dot-path-like name" do
        # sym key :name accessed as string "name" — no dots, just sym root key
        data = { name: "Jane" }
        expect(described_class.apply({ "var" => "name" }, data)).to eq("Jane")
      end
    end

    describe "val with mixed sym/str keys" do
      it "accesses sym key with val" do
        data = { score: 99 }
        expect(described_class.apply({ "val" => "score" }, data)).to eq(99)
      end

      it "accesses str key with val" do
        data = { "score" => 99 }
        expect(described_class.apply({ "val" => "score" }, data)).to eq(99)
      end

      it "accesses nested sym keys with val array path" do
        data = { user: { name: "Alice" } }
        expect(described_class.apply({ "val" => ["user", "name"] }, data)).to eq("Alice")
      end

      it "accesses mixed sym/str nested keys with val array path" do
        data = { "user" => { name: "Alice", "age" => 30 } }
        expect(described_class.apply({ "val" => ["user", "name"] }, data)).to eq("Alice")
        expect(described_class.apply({ "val" => ["user", "age"] }, data)).to eq(30)
      end

      it "accesses 3-level deep mixed keys with val" do
        data = { a: { "b" => { c: 7 } } }
        expect(described_class.apply({ "val" => ["a", "b", "c"] }, data)).to eq(7)
      end

      it "returns nil for missing key on sym data with val" do
        data = { user: { name: "Alice" } }
        expect(described_class.apply({ "val" => ["user", "missing"] }, data)).to be_nil
      end
    end

    describe "iterators over arrays of hashes with symbol keys" do
      it "map over array of sym-key hashes" do
        data = { users: [{ name: "Alice" }, { name: "Bob" }] }
        rule = { "map" => [{ "var" => "users" }, { "var" => "name" }] }
        expect(described_class.apply(rule, data)).to eq(["Alice", "Bob"])
      end

      it "map over array of mixed-key hashes" do
        data = { users: [{ name: "Alice", "age" => 30 }, { "name" => "Bob", age: 25 }] }
        rule = { "map" => [{ "var" => "users" }, { "var" => "name" }] }
        expect(described_class.apply(rule, data)).to eq(["Alice", "Bob"])
      end

      it "filter over array of sym-key hashes" do
        data = { users: [{ name: "Alice", age: 30 }, { name: "Bob", age: 17 }] }
        rule = { "filter" => [{ "var" => "users" }, { ">=" => [{ "var" => "age" }, 18] }] }
        expect(described_class.apply(rule, data)).to eq([{ name: "Alice", age: 30 }])
      end

      it "reduce over array of sym-key hashes" do
        data = { items: [{ value: 10 }, { value: 20 }, { value: 5 }] }
        rule = { "reduce" => [
          { "var" => "items" },
          { "+" => [{ "var" => "accumulator" }, { "var" => "current.value" }] },
          0
        ] }
        expect(described_class.apply(rule, data)).to eq(35)
      end

      it "all with sym-key hashes" do
        data = { scores: [{ value: 10 }, { value: 20 }] }
        rule = { "all" => [{ "var" => "scores" }, { ">" => [{ "var" => "value" }, 0] }] }
        expect(described_class.apply(rule, data)).to eq(true)
      end

      it "some with sym-key hashes" do
        data = { scores: [{ value: -1 }, { value: 5 }] }
        rule = { "some" => [{ "var" => "scores" }, { ">" => [{ "var" => "value" }, 0] }] }
        expect(described_class.apply(rule, data)).to eq(true)
      end

      it "none with sym-key hashes" do
        data = { scores: [{ value: -1 }, { value: -5 }] }
        rule = { "none" => [{ "var" => "scores" }, { ">" => [{ "var" => "value" }, 0] }] }
        expect(described_class.apply(rule, data)).to eq(true)
      end

      it "map with sym array key and nested sym hash accessing multiple fields" do
        data = { products: [{ name: "Widget", price: 9 }, { name: "Gadget", price: 99 }] }
        rule = { "map" => [
          { "var" => "products" },
          { "cat" => [{ "var" => "name" }, ": $", { "var" => "price" }] }
        ] }
        expect(described_class.apply(rule, data)).to eq(["Widget: $9", "Gadget: $99"])
      end
    end

    describe "deeply mixed sym/str data in complex rules" do
      it "if rule reading sym key" do
        data = { age: 20 }
        rule = { "if" => [{ ">=" => [{ "var" => "age" }, 18] }, "adult", "minor"] }
        expect(described_class.apply(rule, data)).to eq("adult")
      end

      it "missing with sym-key data reports missing keys" do
        data = { name: "Alice" }
        expect(described_class.apply({ "missing" => ["name", "email"] }, data)).to eq(["email"])
      end

      it "missing_some with sym-key data" do
        data = { name: "Alice" }
        expect(described_class.apply({ "missing_some" => [1, ["name", "email"]] }, data)).to eq([])
      end

      it "nested rule with all mixed: sym data, str rule keys, dot notation" do
        data = { "user" => { role: "admin", profile: { active: true } } }
        rule = { "and" => [
          { "==" => [{ "var" => "user.role" }, "admin"] },
          { "==" => [{ "var" => "user.profile.active" }, true] }
        ] }
        expect(described_class.apply(rule, data)).to eq(true)
      end

      it "does not mutate original data with sym keys after iteration" do
        data = { items: [{ value: 1 }, { value: 2 }] }
        original_keys = data[:items].first.keys
        described_class.apply({ "map" => [{ "var" => "items" }, { "var" => "value" }] }, data)
        expect(data[:items].first.keys).to eq(original_keys)
      end
    end
  end

  describe "Symbol values in comparisons (Ruby-specific, not in JSON fixtures)" do
    # Symbols are converted to String via to_s before comparison.
    # JSON has no Symbol type, so these tests live here.

    describe "== (soft equals)" do
      it "Symbol equals matching String" do
        expect(described_class.apply({ "==" => [{ "var" => "s" }, "admin"] }, { s: :admin })).to eq(true)
      end

      it "Symbol does not equal non-matching String" do
        expect(described_class.apply({ "==" => [{ "var" => "s" }, "user"] }, { s: :admin })).to eq(false)
      end

      it "two identical Symbols are equal" do
        expect(described_class.apply({ "==" => [{ "var" => "a" }, { "var" => "b" }] }, { a: :foo, b: :foo })).to eq(true)
      end

      it "two different Symbols are not equal" do
        expect(described_class.apply({ "==" => [{ "var" => "a" }, { "var" => "b" }] }, { a: :foo, b: :bar })).to eq(false)
      end
    end

    describe "=== (strict equals)" do
      it "Symbol strict-equals matching String" do
        expect(described_class.apply({ "===" => [{ "var" => "s" }, "admin"] }, { s: :admin })).to eq(true)
      end

      it "Symbol does not strict-equal non-matching String" do
        expect(described_class.apply({ "===" => [{ "var" => "s" }, "user"] }, { s: :admin })).to eq(false)
      end
    end

    describe "!= and !==" do
      it "Symbol != different String" do
        expect(described_class.apply({ "!=" => [{ "var" => "s" }, "user"] }, { s: :admin })).to eq(true)
      end

      it "Symbol !=" + " same String is false" do
        expect(described_class.apply({ "!=" => [{ "var" => "s" }, "admin"] }, { s: :admin })).to eq(false)
      end

      it "Symbol !== different String" do
        expect(described_class.apply({ "!==" => [{ "var" => "s" }, "user"] }, { s: :admin })).to eq(true)
      end
    end

    describe "< > <= >= (ordering)" do
      it "Symbol compared with < to String" do
        expect(described_class.apply({ "<" => [{ "var" => "s" }, "b"] }, { s: :a })).to eq(true)
      end

      it "Symbol compared with > to String" do
        expect(described_class.apply({ ">" => [{ "var" => "s" }, "a"] }, { s: :b })).to eq(true)
      end

      it "Symbol compared with <= to same String" do
        expect(described_class.apply({ "<=" => [{ "var" => "s" }, "a"] }, { s: :a })).to eq(true)
      end

      it "Symbol compared with >= to same String" do
        expect(described_class.apply({ ">=" => [{ "var" => "s" }, "z"] }, { s: :z })).to eq(true)
      end
    end

    describe "in (includes)" do
      it "String in array containing a matching Symbol" do
        expect(described_class.apply({ "in" => ["admin", { "var" => "roles" }] }, { roles: [:admin, :user] })).to eq(true)
      end

      it "String not in array with no matching Symbol" do
        expect(described_class.apply({ "in" => ["guest", { "var" => "roles" }] }, { roles: [:admin, :user] })).to eq(false)
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
