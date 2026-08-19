#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CASE_ID="${1:-}"
TIMEOUT_SEC="${TIMEOUT_SEC:-45}"

if [[ -z "$CASE_ID" ]]; then
  echo "Usage: TIMEOUT_SEC=45 bash p1_check_case_fast.sh <case_id>" >&2
  exit 2
fi

if ! command -v timeout >/dev/null 2>&1; then
  echo "ERROR: timeout command not found" >&2
  exit 127
fi

set +e
timeout --kill-after=5s "${TIMEOUT_SEC}s" \
  bash "$ROOT_DIR/p1_check_case.sh" "$CASE_ID"
code=$?
set -e

if [[ "$code" -eq 124 || "$code" -eq 137 ]]; then
  echo "FAST_CHECK_TIMEOUT: case=$CASE_ID seconds=$TIMEOUT_SEC" >&2
  echo "Treat this as a failing RTL attempt. Do not debug vvp/gdb; simplify/fix the RTL and rerun." >&2
fi

exit "$code"
