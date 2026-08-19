#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-/workspace}"

if [[ ! -d "$ROOT_DIR/problems/P1" ]]; then
  echo "ERROR: $ROOT_DIR does not look like an EDAthon workspace." >&2
  exit 2
fi

missing=0

need_cmd() {
  local name="$1"
  if command -v "$name" >/dev/null 2>&1; then
    echo "OK: command $name -> $(command -v "$name")"
  else
    echo "MISSING: command $name" >&2
    missing=1
  fi
}

need_py() {
  local module="$1"
  if python3 - "$module" <<'PY' >/dev/null 2>&1
import importlib.util
import sys
sys.exit(0 if importlib.util.find_spec(sys.argv[1]) else 1)
PY
  then
    echo "OK: python module $module"
  else
    echo "MISSING: python module $module" >&2
    missing=1
  fi
}

need_cmd python3
need_cmd timeout
need_cmd iverilog
need_cmd vvp

need_py pytest
need_py cocotb
need_py cocotb_tools.runner

if [[ -f "$ROOT_DIR/toolkit/tools/info.py" ]]; then
  echo "OK: toolkit/tools/info.py"
else
  echo "WARN: toolkit/tools/info.py not found"
fi

if [[ -f "$ROOT_DIR/toolkit/tools/check.py" ]]; then
  echo "OK: toolkit/tools/check.py"
else
  echo "WARN: toolkit/tools/check.py not found"
fi

if [[ "$missing" -ne 0 ]]; then
  echo ""
  echo "ENV_CHECK_FAIL"
  echo "Do not switch to an external Docker image during the contest."
  echo "Use the official container's allowed tools only, and ask the organizer if required benchmark dependencies are missing."
  exit 127
fi

echo ""
echo "ENV_CHECK_OK"
