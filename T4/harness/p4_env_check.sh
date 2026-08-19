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

need_dir() {
  if [[ ! -d "$1" ]]; then
    echo "MISSING dir: $1" >&2
    FAIL=1
  else
    echo "OK dir: $1"
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

echo "== P4 environment check =="
need_dir "$ROOT/problems/P4"
need_dir "$ROOT/problems/P4/data/cases"
need_file "$ROOT/problems/P4/case_ids.txt"
need_file "$ROOT/problems/P4/data/asap7.lydrc"
need_file "$ROOT/toolkit/opencode_harness/edathon_harness.py"
need_file "$ROOT/toolkit/tools/check.py"
need_cmd python3

if command -v klayout >/dev/null 2>&1; then
  echo "OK cmd: klayout -> $(command -v klayout)"
  klayout -v 2>/dev/null || true
else
  echo "WARN: klayout not on PATH; quick structural checks can still run, but GDS render/DRC proxy cannot." >&2
fi

if [[ "$FAIL" -eq 0 ]]; then
  echo "P4_ENV_CHECK_OK"
else
  echo "P4_ENV_CHECK_FAIL" >&2
fi

exit "$FAIL"
