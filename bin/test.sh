#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Config
OFFICIAL_REF="${OFFICIAL_REF:-main}"
OFFICIAL_REPO="${OFFICIAL_REPO:-json-logic/.github}"
TMP_DIR="${TMP_DIR:-$ROOT_DIR/tmp}"
OFFICIAL_DIR="$TMP_DIR/official-tests"

# Helpers
log() { printf "\n\033[1m%s\033[0m\n" "$*"; }

log "Installing gems"
bundle install

# ---- Official tests (json-logic/.github/tests) ----
log "Fetching official tests from GitHub: $OFFICIAL_REPO@$OFFICIAL_REF"

rm -rf "$OFFICIAL_DIR"
mkdir -p "$OFFICIAL_DIR"

OFFICIAL_URL="https://codeload.github.com/${OFFICIAL_REPO}/tar.gz/${OFFICIAL_REF}"

# Extract only: .github-<ref>/tests -> tmp/official-tests
curl -fsSL "$OFFICIAL_URL" \
  | tar -xz \
      --strip-components=2 \
      -C "$OFFICIAL_DIR" \
      ".github-${OFFICIAL_REF}/tests" 2>/dev/null \

log "Official tests ready at: $OFFICIAL_DIR"

log "Running official tests"
OFFICIAL_OUT="$TMP_DIR/official-rspec.out"

set +e
OFFICIAL_TESTS_DIR="$OFFICIAL_DIR" bundle exec rspec spec/official_spec.rb | tee "$OFFICIAL_OUT"
OFFICIAL_EXIT=${PIPESTATUS[0]}
set -e

# Parse totals from RSpec summary
TOTAL=$(ruby -e '
  s = STDIN.read
  m = s.match(/(\d+)\s+examples?,\s+(\d+)\s+failures?/)
  abort "Could not parse RSpec summary" unless m
  puts m[1]
' < "$OFFICIAL_OUT")

FAILURES=$(ruby -e '
  s = STDIN.read
  m = s.match(/(\d+)\s+examples?,\s+(\d+)\s+failures?/)
  abort "Could not parse RSpec summary" unless m
  puts m[2]
' < "$OFFICIAL_OUT")

PASSED=$((TOTAL - FAILURES))

mkdir -p results
cat > results/ruby.json <<EOF
{
  "totals": {
    "shiny_json_logic": {
      "passed": $PASSED,
      "total": $TOTAL
    }
  }
}
EOF

echo ""
echo "=== Summary ==="
echo "Official: ${PASSED}/${TOTAL} (failures: ${FAILURES}, exit: ${OFFICIAL_EXIT})"
