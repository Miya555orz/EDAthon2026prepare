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

echo "== P3 environment check =="
need_dir "$ROOT/problems/P3"
need_file "$ROOT/problems/P3/case_ids.txt"
need_file "$ROOT/problems/P3/starter/global_place.tcl"
need_file "$ROOT/problems/P3/utils/run_case.py"
need_file "$ROOT/toolkit/opencode_harness/edathon_harness.py"
need_file "$ROOT/toolkit/tools/check.py"
need_cmd python3

if command -v openroad >/dev/null 2>&1; then
  echo "OK cmd: openroad -> $(command -v openroad)"
  echo "openroad version: $(openroad -version 2>/dev/null || true)"
else
  echo "WARN: openroad not on PATH; structural check can still run, ORFS placement/full cannot." >&2
fi

if [[ -n "${CHIPBENCH_ORFS_FLOW_DIR:-}" ]]; then
  if [[ -f "$CHIPBENCH_ORFS_FLOW_DIR/Makefile" && -d "$CHIPBENCH_ORFS_FLOW_DIR/scripts" ]]; then
    echo "OK CHIPBENCH_ORFS_FLOW_DIR=$CHIPBENCH_ORFS_FLOW_DIR"
  else
    echo "WARN: CHIPBENCH_ORFS_FLOW_DIR is set but does not look like ORFS flow: $CHIPBENCH_ORFS_FLOW_DIR" >&2
  fi
else
  echo "INFO: CHIPBENCH_ORFS_FLOW_DIR not set. For real P3 ORFS runs, set it to official /.../flow."
fi

if [[ -n "${CHIPBENCH_DESIGN_HOME:-}" ]]; then
  if [[ -d "$CHIPBENCH_DESIGN_HOME/nangate45" ]]; then
    echo "OK CHIPBENCH_DESIGN_HOME=$CHIPBENCH_DESIGN_HOME"
  else
    echo "WARN: CHIPBENCH_DESIGN_HOME is set but missing nangate45/: $CHIPBENCH_DESIGN_HOME" >&2
  fi
else
  echo "INFO: CHIPBENCH_DESIGN_HOME not set. For real P3 ORFS runs, set it to official design home."
fi

if [[ "$FAIL" -eq 0 ]]; then
  echo "P3_ENV_CHECK_OK"
else
  echo "P3_ENV_CHECK_FAIL" >&2
fi

exit "$FAIL"
