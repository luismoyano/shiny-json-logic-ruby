#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Config
COMPAT_REF="${COMPAT_REF:-main}"
COMPAT_REPO="${COMPAT_REPO:-json-logic/compat-tables}"
TMP_DIR="${TMP_DIR:-$ROOT_DIR/tmp}"
SUITES_DIR="$TMP_DIR/compat-suites"

# Helpers
log() { printf "\n\033[1m%s\033[0m\n" "$*"; }

log "Installing gems"
bundle install

# ---- Compatibility suites (optional but recommended) ----
# Download ONLY the suites folder from the compat-tables repo archive.
# This avoids a full git clone and works everywhere as long as curl+tar exist.

log "Fetching compat suites from GitHub: $COMPAT_REPO@$COMPAT_REF"

rm -rf "$SUITES_DIR"
mkdir -p "$SUITES_DIR"

ARCHIVE_URL="https://codeload.github.com/${COMPAT_REPO}/tar.gz/${COMPAT_REF}"

# Extract only: compat-tables-<ref>/suites -> tmp/compat-suites
# Different refs create different top-level folder names; we strip the first path component.
curl -fsSL "$ARCHIVE_URL" \
  | tar -xz \
      --strip-components=2 \
      -C "$SUITES_DIR" \
      "compat-tables-${COMPAT_REF}/suites" 2>/dev/null \

log "Compat suites ready at: $SUITES_DIR"

log "Running compatibility suite"
COMPAT_OUT="$TMP_DIR/compat-rspec.out"

set +e
COMPAT_SUITES_DIR="$SUITES_DIR" bundle exec rspec spec/compatibility_spec.rb | tee "$COMPAT_OUT"
COMPAT_EXIT=${PIPESTATUS[0]}
set -e

# Parse totals from RSpec summary
TOTAL=$(ruby -e '
  s = STDIN.read
  m = s.match(/(\d+)\s+examples?,\s+(\d+)\s+failures?/)
  abort "Could not parse RSpec summary" unless m
  puts m[1]
' < "$COMPAT_OUT")

FAILURES=$(ruby -e '
  s = STDIN.read
  m = s.match(/(\d+)\s+examples?,\s+(\d+)\s+failures?/)
  abort "Could not parse RSpec summary" unless m
  puts m[2]
' < "$COMPAT_OUT")

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

echo "Compat: ${PASSED}/${TOTAL} (failures: ${FAILURES}, exit: ${COMPAT_EXIT})"
