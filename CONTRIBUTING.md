# Contributing to ShinyJsonLogic

Thanks for contributing to Shiny!!

## Quick start

```bash
bin/setup
bundle exec rspec
```

## What we’re looking for

- Spec alignment improvements
- Missing operators
- Edge-case tests
- Performance improvements (with tests)

## Bug reports

Please include:

- The JSON Logic rule (as Ruby Hash or JSON)
- The data input
- Expected output
- Actual output
- Ruby version (`ruby -v`) and gem version

A minimal reproduction is ideal.

## Adding an operator

1. Implement the operator in `lib/shiny_json_logic/operations/`.
2. Add focused specs under `spec/` (and/or add cases to the compatibility suite if present).
3. Keep behavior predictable and aligned with JSON Logic semantics.
4. Avoid adding runtime dependencies.

## Code style

Keep changes small and explicit. Prefer tests that document behavior.
