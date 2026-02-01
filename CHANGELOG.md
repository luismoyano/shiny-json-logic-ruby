# Changelog

All notable changes to this project will be documented in this file.

## [0.1.8] - 2026-02-01
### Changed
- Removes debug prints.

## [0.1.8] - 2026-02-02
### Added
- Adds support for `preserve` operator.
- Adds support for division with only one argument.
### Changed
- Throws error when division receives no arguments

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
