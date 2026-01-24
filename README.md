# ShinyJsonLogic ✨

> Shine bright like a Ruby 💎

A **working** JSON Logic implementation in Ruby.

This gem exists because the official JSONLogic Ruby implementation has been incomplete and unmaintained for quite a while.

`ShinyJsonLogic` aims to be predictable, aligned with specs, test-driven and ready to use in Ruby's production code.

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
Or install it yourself:

```bash
gem install shiny_json_logic
```

## Usage

Basic usage is intentionally simple:

``` ruby
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

### Nested Logic
You can nest rules as deeply as needed:

``` ruby
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

### Supported operators

The goal is full JSON Logic coverage. Currently supported:

#### Logic

`if, and, or, !, !!`

#### Comparison

`==, ===, !=, !==, >, >=, <, <=`

#### Data access

`var, missing, missing_some, val, exists`

#### Math

`+, -, *, /, %`
`min, max`

#### Strings

`cat, substr`

#### Arrays

`merge, in, ?? (Coalesce operator)`

#### Iterable operations
`map, reduce, filter, some, all, none`

(See lib/shiny_json_logic/operations for the authoritative list.)

## Development

After checking out the repo:

``` bash
bin/setup
bundle exec rspec
```

You can also open a console with:

``` bash
bin/console
```

To install the gem locally:

``` bash
bundle exec rake install
```

## Contributing

Contributions are welcome — especially:

spec alignment improvements, missing operators, edge-case tests or performance improvements

Please include tests with any change.

Repository: https://github.com/luismoyano/shiny_json_logic

## License

MIT License.

Use it, fork it, ship it (: