# Changelog

All notable changes to this project will be documented in this file.

## [0.2.11] - 2026-02-09
### Changed
- Removes monkey patches in favour of isolated modules.

### Added
- Supports hashes with string or symbol access indifferently (e.g. `{"a" => 1}` can be accessed with `:a` or `"a"`).

## [0.2.9] - 2026-02-08
### Added
- New specific error classes: `Errors::InvalidArguments`, `Errors::NotANumber`, `Errors::UnknownOperator`
  - All inherit from `Errors::Base`, so existing `rescue Errors::Base` will continue to work
### Changed
- Refactors max/min operators to use shared MinMaxCollection module
- Eliminates code duplication between max.rb and min.rb

## [0.2.8] - 2026-02-07
### Changed
- Improves error handling in try/throw/reduce operators
- Fixes error propagation in iterators (map/filter/all/some/none)
- Compatibility improved from 98.3% to 99.7%

## [0.2.7] - 2026-02-05
### Changed
- Refactors internal architecture to always enable lazy loading
- Improves compatibility of arithmetic operators
- Improves compatibility of logical operators

## [0.2.6] - 2026-02-02
### Changed
- Fixes bug with iterable when rules are empty

## [0.2.5] - 2026-02-02
### Changed
- Improves compatibility of Iterative operations

## [0.2.4] - 2026-02-02
### Changed
- Improves compatibility of addition operator
- Fixed bug when attempting to evaluate empty rules.

## [0.2.3] - 2026-02-02
### Changed
- Improves compatibility of multiplication operator

## [0.2.2] - 2026-02-02
### Changed
- Improves compatibility of modulo operator

## [0.2.1] - 2026-02-02
### Changed
- Improves compatibility of subtraction operator

## [0.2.0] - 2026-02-02
### Changed
- Improves compatibility of division operator

## [0.1.9] - 2026-02-02
### Added
- Adds support for `preserve` operator.
- Adds support for division with only one argument.
### Changed
- Throws error when division receives no arguments

## [0.1.8] - 2026-02-01
### Changed
- Removes debug prints.

## [0.1.7] - 2026-02-01
### Added
- Adds support for `try` and `throw` operators.
- Introduces context mechanism to allow other operations to leverage context data.
### Changed
- Refactors internal architecture to support context-aware operations.
- Returns to recursive approach as it is easier to develop this way
- If now handles rules calculation lazily

## [0.1.6] - 2026-01-25
### Added
- Improve CI support for Ruby 4.0 (no runtime changes).
- Adds GitHub Actions CI workflow for Ruby 4.0.

## [0.1.5] - 2026-01-25
### Changed
- Improve RubyGems gem description (no runtime changes).

## [0.1.4] - 2026-01-25
### Changed
- Improve RubyGems metadata and gem description (no runtime changes).
- Improves README md

## [0.1.3]
### Added
- Adds Support for `val`, `exists` and `??` operators.

## [0.1.0]
- Initial release with support for legacy JSON Logic operators.
