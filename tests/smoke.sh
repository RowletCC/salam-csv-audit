#!/bin/sh
set -eu

salam build src/main.salam --output=csv-audit >/dev/null 2>&1
clean=$(./csv-audit)
printf '%s\n' "$clean" | grep -q 'Duplicate IDs:  0'
printf '%s\n' "$clean" | grep -q 'Total amount:  28.75'

set +e
dirty=$(CSV_AUDIT_FILE=examples/issues.csv ./csv-audit)
status=$?
set -e
test "$status" -eq 2
printf '%s\n' "$dirty" | grep -q 'Malformed rows:  1'
printf '%s\n' "$dirty" | grep -q 'Missing required cells:  2'
printf '%s\n' "$dirty" | grep -q 'Duplicate IDs:  1'
printf '%s\n' "$dirty" | grep -q 'Invalid amounts:  2'

set +e
headers=$(CSV_AUDIT_FILE=examples/bad-headers.csv ./csv-audit)
status=$?
set -e
test "$status" -eq 2
printf '%s\n' "$headers" | grep -q 'Blank column names:  1'
printf '%s\n' "$headers" | grep -q 'Duplicate column names:  1'
echo 'Smoke test passed'
