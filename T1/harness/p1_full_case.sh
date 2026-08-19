#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CASE_ID="${1:-}"
TIMEOUT_SEC="${TIMEOUT_SEC:-240}"
LOG_DIR="${LOG_DIR:-$ROOT_DIR/.logs}"

if [[ -z "$CASE_ID" ]]; then
  echo "Usage: TIMEOUT_SEC=240 bash p1_full_case.sh <case_id>" >&2
  exit 2
fi

mkdir -p "$LOG_DIR"
mkdir -p "${WORKDIR_BASE:-$ROOT_DIR/.runs}"
export WORKDIR_BASE="${WORKDIR_BASE:-$ROOT_DIR/.runs}"
export KEEP_WORKDIR="${KEEP_WORKDIR:-0}"

LOG_FILE="$LOG_DIR/p1_${CASE_ID}_full_$(date +%Y%m%d_%H%M%S).log"

echo "Running full check: $CASE_ID"
echo "LOG_FILE=$LOG_FILE"

set +e
timeout --kill-after=10s "${TIMEOUT_SEC}s" \
  bash "$ROOT_DIR/p1_check_case.sh" "$CASE_ID" > "$LOG_FILE" 2>&1
code=$?
set -e

if [[ "$code" -eq 124 || "$code" -eq 137 ]]; then
  echo "FULL_CHECK_TIMEOUT: case=$CASE_ID seconds=$TIMEOUT_SEC" >&2
fi

if [[ "$code" -eq 0 ]]; then
  grep -E 'collected |[0-9]+ passed|[0-9]+ failed|PASSED$|FAILED|PASS=|FAIL=' "$LOG_FILE" | tail -n 30 || true
else
  tail -n 120 "$LOG_FILE"
fi

echo "FULL_EXIT=$code"
exit "$code"
