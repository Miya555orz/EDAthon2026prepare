#!/usr/bin/env bash
set -u

ROOT="${1:-/workspace}"
FAIL=0

need_file() {
  if [[ ! -f "$1" ]]; then
    echo "MISSING file: $1" >&2
    FAIL=1
  else
    echo "OK file: $1"
  fi
}

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "MISSING cmd: $1" >&2
    FAIL=1
  else
    echo "OK cmd: $1 -> $(command -v "$1")"
  fi
}

echo "== P2 environment check =="
need_file "$ROOT/problems/P2/case_ids.txt"
need_file "$ROOT/problems/P2/utils/evaluate_pluto_case.py"
need_file "$ROOT/toolkit/opencode_harness/edathon_harness.py"
need_file "$ROOT/toolkit/tools/check.py"
need_cmd python3
need_cmd iverilog
need_cmd vvp
need_cmd yosys

if [[ "$FAIL" -eq 0 ]]; then
  echo "P2_ENV_CHECK_OK"
else
  echo "P2_ENV_CHECK_FAIL" >&2
fi

exit "$FAIL"
