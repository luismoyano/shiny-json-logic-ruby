# ShinyJsonLogic ✨

![Compatibility](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/luismoyano/shiny-json-logic-ruby/master/badges/compat.json)
[![Gem Version](https://badge.fury.io/rb/shiny_json_logic.svg?icon=si%3Arubygems)](https://badge.fury.io/rb/shiny_json_logic)
![Ruby](https://img.shields.io/badge/ruby-%3E%3D%202.7-brightgreen)

> **A boring, correct and production-ready JSONLogic implementation for Ruby. ✨** 

**ShinyJsonLogic** is a **pure Ruby**, **zero-dependency** JSON Logic implementation, designed to offer a reliable and well-tested engine for Ruby applications.

This gem focuses on predictable behavior, strict spec alignment, high compatibility and long-term maintainability.

---

## Why ShinyJsonLogic?

- 🧩 **Zero runtime dependencies** (stdlib-only). Just plug & play!
- 🕰️ **Ruby 2.7+ compatible**, one of the lowest minimum versions supported in the Ruby ecosystem.
- 🔧 **Actively maintained** and continuously improved.
- 📊 **Highest JSONLogic compatibility in the Ruby ecosystem**, as measured against the official test suites.

If you want JSON Logic to *just work* in Ruby, this is the safe default.

---
# Test it for yourself!
Try it out in the sandbox at [jsonlogicruby.com](https://jsonlogicruby.com/playground) or run the official test suite with `bin/test.sh` to see the compatibility for yourself.

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

**Why should you give us a chance?**
- 🐛 Better spec compliance and fewer edge-case bugs
- ✨ Support for new operators (`val`, `exists`, `??`, `try`, `throw`, `preserve`)
- 🔧 Actively maintained
- 🧪 Higher test coverage against official JSONLogic test suites

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

---

## Compatibility

Compatibility is measured against the official JSONLogic test suite (`json-logic/.github/tests`):

| Test Suite | Status |
|------------|--------|
| **Official tests** | 100% (601/601) |

See `badges/compat.json` for the exact numbers behind the badge.

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

