# ShinyJsonLogic ✨

![Compatibility](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/luismoyano/shiny-json-logic-ruby/master/badges/compat.json)
[![Gem Version](https://badge.fury.io/rb/shiny_json_logic.svg?icon=si%3Arubygems)](https://badge.fury.io/rb/shiny_json_logic)
![Ruby](https://img.shields.io/badge/ruby-%3E%3D%202.4-brightgreen)

> **The fastest AND most compliant JSONLogic implementation for Ruby. ✨** 

**ShinyJsonLogic** is a **pure Ruby**, **zero-dependency** JSON Logic implementation — the only Ruby gem that passes 100% of the official JSON Logic tests, and faster than all competitors on every Ruby version tested.

---

## Why ShinyJsonLogic?

If you've used JSON Logic in Ruby before, you've probably found that other gems don't behave like their JS or Python counterparts: It's either wrong outputs on edge cases, missing operators or subtle bugs... And you end up patching, spawning a JS process or writing the interpreter yourself. Been there.

ShinyJsonLogic fixes that:

- 🚀 **Fastest Ruby JSON Logic gem** — wins across all Ruby versions tested, up to +117% faster than competitors.
- ✅ **100% spec-compliant** — the only Ruby gem that passes all official JSON Logic tests.
- 🧩 **Zero runtime dependencies** (stdlib-only). Just plug & play.
- 🕰️ **Ruby 2.4+ compatible** — one of the lowest minimum versions in the Ruby ecosystem.
- 🔧 **Actively maintained** and continuously improved.

Try it in the sandbox at [jsonlogicruby.com/playground](https://jsonlogicruby.com/playground), or see the full benchmark results at [jsonlogicruby.com/benchmarks](https://jsonlogicruby.com/benchmarks).

---

## Installation

Add it to your Gemfile:

```ruby
gem "shiny_json_logic"
```

Then run:

```bash
bundle install
```

Or install it directly:

```bash
gem install shiny_json_logic
```

and require it in your project:

```ruby
require "shiny_json_logic"
```

---

## Performance

Benchmarked via [jsonlogic_benchmarks](https://github.com/luismoyano/jsonlogic_benchmarks) — automated CI on Linux across all Ruby versions (2.7 through 4.0, with and without YJIT). shiny_json_logic wins across the board, up to **+117% faster** than the next best gem.

See [jsonlogicruby.com/benchmarks](https://jsonlogicruby.com/benchmarks) for the full interactive results.

---

## Migrating from json-logic-ruby

If you're currently using [json-logic-ruby](https://github.com/bhgames/json-logic-ruby), migration is seamless.

ShinyJsonLogic provides `JsonLogic` and `JSONLogic` as aliases, so you only need to swap the gem in your Gemfile:

```diff
- gem "json-logic-ruby"
+ gem "shiny_json_logic"
```

Your existing code will work without changes:

```ruby
require "shiny_json_logic"

# Both of these work exactly as before:
JsonLogic.apply(rule, data)
JSONLogic.apply(rule, data)

# Or use the new module name:
ShinyJsonLogic.apply(rule, data)
```

---

## Usage

Basic usage is intentionally simple:

```ruby
require "shiny_json_logic"

rule = {
  "==" => [
    { "var" => "status" },
    "active"
  ]
}

data = { "status" => "active" }

ShinyJsonLogic.apply(rule, data)
# => true
```

### Nested logic

Rules can be nested arbitrarily:

```ruby
rule = {
  "if" => [
    { "var" => "financing" },
    { "missing" => ["apr"] },
    []
  ]
}

data = { "financing" => true }

ShinyJsonLogic.apply(rule, data)
# => ["apr"]
```

---

## Supported operators

Our goal is **full JSON Logic coverage**.  
Currently implemented operators include:

### Logic
`if`, `and`, `or`, `!`, `!!`, `?:`, `try`✨, `throw`✨

### Comparison
`==`, `===`, `!=`, `!==`, `>`, `>=`, `<`, `<=`

### Data access
`var`, `missing`, `missing_some`, `val`✨, `exists`✨

### Math
`+`, `-`, `*`, `/`, `%`, `min`, `max`

### Strings
`cat`, `substr`

### Arrays
`merge`, `in`, `??`✨ *(coalesce operator)*

### Iterable operations
`map, reduce, filter, some, all, none`

### Evaluation
`preserve`✨

See the [spec](https://jsonlogicruby.com/docs) for the full list of operators and their behavior.

---

## Error Handling

ShinyJsonLogic uses native Ruby exceptions for error handling:

```ruby
# Unknown operators raise an error
ShinyJsonLogic.apply({ "unknown_op" => [1, 2] }, {})
# => raises ShinyJsonLogic::Errors::UnknownOperator

# Invalid arguments raise an error
ShinyJsonLogic.apply({ "+" => ["not", "numbers"] }, {})
# => raises ShinyJsonLogic::Errors::InvalidArguments

# You can use try/throw for controlled error handling within rules
rule = {
  "try" => [
    { "throw" => "Something went wrong" },
    { "cat" => ["Error: ", { "var" => "type" }] }
  ]
}
ShinyJsonLogic.apply(rule, {})
# => "Error: Something went wrong"
```

Error classes:
- `ShinyJsonLogic::Errors::UnknownOperator` - Unknown operator in rule
- `ShinyJsonLogic::Errors::InvalidArguments` - Invalid arguments to operator
- `ShinyJsonLogic::Errors::NotANumber` - NaN result in numeric operation

or rescue the `ShinyJsonLogic::Errors::Base` error class in a single sweep.

---

## Development

After checking out the repo:

```bash
bin/setup
bundle exec rspec
```

Open a console:

```bash
bin/console
```

Install locally:

```bash
bundle install
```
How to run the compatibility test suite:

```bash
bin/test.sh
```

---

## Contributing

Contributions are welcome — especially:

- spec alignment improvements
- missing operators
- edge-case tests
- performance improvements

Please include tests with any change.

Repository:  
https://github.com/luismoyano/shiny_json_logic

---

## License

MIT License.

Use it. Fork it. Ship it. (:

---

> Shine bright like a Ruby 💎  

