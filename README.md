# ShinyJsonLogic ✨

[![Compatibility](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/luismoyano/shiny-json-logic-ruby/master/badges/compat.json)](https://github.com/luismoyano/shiny-json-logic-ruby/actions/workflows/compat.yml)
[![Gem Version](https://badge.fury.io/rb/shiny_json_logic.svg?icon=si%3Arubygems)](https://badge.fury.io/rb/shiny_json_logic)
![Ruby](https://img.shields.io/badge/ruby-%3E%3D%202.7-brightgreen)

> **A boring, correct and production-ready JSON Logic implementation for Ruby. ✨** 

**ShinyJsonLogic** is a **pure Ruby**, **zero-dependency** JSON Logic implementation, designed to offer a reliable and well-tested engine for Ruby applications.

This gem focuses on predictable behavior, strict spec alignment, high compatibility and long-term maintainability.

---

## Why ShinyJsonLogic?

- 🧩 **Zero runtime dependencies** (stdlib-only). Just plug & play!
- 🕰️ **Ruby 2.7+ compatible**, one of the lowest minimum versions supported in the Ruby ecosystem.
- 🔧 **Actively maintained** and continuously improved.
- 📊 **Highest JSON Logic compatibility in the Ruby ecosystem**, as measured against the official test suites.
- 🔁 **Iterative (non-recursive) evaluation:** handles deeply nested or very large rules without stack overflows.
- ⭐ **Only Ruby implementation supporting the latest standard operators** (`val`, `exists`, `??`)

If you want JSON Logic to *just work* in Ruby, this is the safe default.

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
`if`, `and`, `or`, `!`, `!!`

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

📌 **Note:**  
`val`, `exists` and `??` are **only supported by ShinyJsonLogic** among Ruby implementations.

(See `lib/shiny_json_logic/operations` for the authoritative list.)

---

## Compatibility

Compatibility is measured automatically against the official JSONLogic test suites from `json-logic/compat-tables`.
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
bundle exec rake install
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

