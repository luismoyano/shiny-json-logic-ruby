# ShinyJsonLogic ✨

> Shine bright like a Ruby 💎  
> **A boring, correct, and production-ready JSON Logic implementation for Ruby.**

**ShinyJsonLogic** is a **pure Ruby**, **zero-dependency** implementation of the JSON Logic specification.

We exist because the original Ruby implementation has been neglected for years.

This gem focuses on predictable behavior, strict spec alignment, high compatibility and long-term maintainability.

---

## Why ShinyJsonLogic?

- ✅ **Zero runtime dependencies** (stdlib-only). Just plug & play!
- ✅ **Ruby 2.7+ compatible, one of the lowest among other Ruby implementations**
- ✅ **Actively maintained**
- ✅ **High JSON Logic spec coverage**
- ✅ **Iterative approach:** Stop worrying about long statements breaking your app.
- ⭐ **Only Ruby implementation supporting the new standard operations up to date.**

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

```rubyruby
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
`val`, `exists` and `??` are **only supported by ShinyJsonLogic** at the moment.

(See `lib/shiny_json_logic/operations` for the authoritative list.)

---

## Compatibility

ShinyJsonLogic is designed to track the official JSON Logic specification as closely as possible.

A compatibility PR against the JSON Logic test tables is currently in progress and will be linked here once merged.

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
