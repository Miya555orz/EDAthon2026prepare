#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CASE_ID="${1:-}"
TIMEOUT_SEC="${TIMEOUT_SEC:-30}"
LOG_DIR="${LOG_DIR:-$ROOT_DIR/.logs}"

if [[ -z "$CASE_ID" ]]; then
  echo "Usage: TIMEOUT_SEC=30 bash p1_probe_case.sh <case_id>" >&2
  exit 2
fi

if ! command -v timeout >/dev/null 2>&1; then
  echo "ERROR: timeout command not found" >&2
  exit 127
fi

PROBLEM_DIR="$ROOT_DIR/problems/P1"
CASE_SRC="$PROBLEM_DIR/data/cases/$CASE_ID"
SUB_CASE="$ROOT_DIR/submission/P1/$CASE_ID"
RUN_BASE="${WORKDIR_BASE:-$ROOT_DIR/.runs_probe}"

if [[ ! -d "$CASE_SRC" ]]; then
  echo "ERROR: unknown P1 case: $CASE_ID" >&2
  echo "Hint: see $PROBLEM_DIR/case_ids.txt" >&2
  exit 2
fi

mkdir -p "$RUN_BASE"
mkdir -p "$LOG_DIR"
WORKDIR="$(mktemp -d "$RUN_BASE/p1_${CASE_ID}_XXXXXX")"

cleanup() {
  code=$?
  if [[ "${KEEP_WORKDIR:-1}" == "1" || "$code" -ne 0 ]]; then
    echo "WORKDIR kept: $WORKDIR" >&2
  else
    rm -rf "$WORKDIR"
  fi
  exit "$code"
}
trap cleanup EXIT

cp -R "$CASE_SRC" "$WORKDIR/case"

if [[ -d "$SUB_CASE" ]]; then
  while IFS= read -r -d '' rel; do
    rel="${rel#./}"
    mkdir -p "$(dirname "$WORKDIR/case/code/$rel")"
    cp "$SUB_CASE/$rel" "$WORKDIR/case/code/$rel"
  done < <(cd "$SUB_CASE" && find . -type f -print0)
else
  echo "WARN: no submission found at $SUB_CASE; testing starter RTL." >&2
fi

TASK_DIR="$WORKDIR/case"
CODE_DIR="$TASK_DIR/code"
SRC_DIR="$CODE_DIR/src"
RUNDIR="$CODE_DIR/rundir"
ENV_FILE="$SRC_DIR/.env"

for tool in python3 pytest iverilog vvp; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "ERROR: $tool not found in this Docker/container." >&2
    exit 127
  fi
done

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: missing $ENV_FILE" >&2
  exit 2
fi

mkdir -p "$RUNDIR/harness/.cache"

ensure_link() {
  local link="$1"
  local target="$2"
  if [[ -L "$link" ]]; then
    rm -f "$link"
  elif [[ -e "$link" ]]; then
    return 0
  fi
  ln -s "$target" "$link" 2>/dev/null || true
}

ensure_link /code "$CODE_DIR"
ensure_link /src "$SRC_DIR"
ensure_link /rundir "$RUNDIR"

while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%%#*}"
  line="$(printf '%s' "$line" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
  [[ -z "$line" ]] && continue
  key="$(printf '%s' "$line" | sed -E 's/[[:space:]]*=.*$//; s/[[:space:]]+$//')"
  val="$(printf '%s' "$line" | sed -E 's/^[^=]*=[[:space:]]*//; s/[[:space:]]+$//')"
  export "$key=$val"
done < "$ENV_FILE"

export PYTHONPATH="$SRC_DIR${PYTHONPATH:+:$PYTHONPATH}"
if [[ -n "${VERILOG_SOURCES:-}" ]]; then
  export VERILOG_SOURCES="${VERILOG_SOURCES//\/code\//$CODE_DIR/}"
fi

cd "$RUNDIR"

NODE="${PYTEST_NODE:-}"
if [[ -z "$NODE" ]]; then
  COLLECT_LOG="$RUNDIR/probe_collect.log"
  set +e
  pytest --collect-only -q "$SRC_DIR/test_runner.py" > "$COLLECT_LOG" 2>&1
  collect_code=$?
  set -e
  if [[ "$collect_code" -ne 0 ]]; then
    cat "$COLLECT_LOG"
    exit "$collect_code"
  fi
  NODE="$(sed -n '/::/p' "$COLLECT_LOG" | head -n 1)"
fi

if [[ -z "$NODE" ]]; then
  echo "ERROR: no pytest node collected from $SRC_DIR/test_runner.py" >&2
  exit 2
fi

NODE_FILE="${NODE%%::*}"
if [[ "$NODE_FILE" != /* && ! -f "$NODE_FILE" && -f "$CODE_DIR/$NODE_FILE" ]]; then
  NODE="$CODE_DIR/$NODE"
fi

echo "Running probe for $TASK_DIR"
echo "TOPLEVEL=${TOPLEVEL:-} MODULE=${MODULE:-} SIM=${SIM:-icarus}"
echo "VERILOG_SOURCES=${VERILOG_SOURCES:-}"
echo "PYTEST_NODE=$NODE"
LOG_FILE="$LOG_DIR/p1_${CASE_ID}_probe_$(date +%Y%m%d_%H%M%S).log"
echo "LOG_FILE=$LOG_FILE"

set +e
timeout --kill-after=5s "${TIMEOUT_SEC}s" \
  pytest -s -o cache_dir="$RUNDIR/harness/.cache" "$NODE" -v > "$LOG_FILE" 2>&1
code=$?
set -e

if [[ "$code" -eq 124 || "$code" -eq 137 ]]; then
  echo "PROBE_TIMEOUT: case=$CASE_ID seconds=$TIMEOUT_SEC" >&2
  echo "Treat this as a failing RTL attempt. Do not use gdb; simplify/fix RTL and rerun probe." >&2
fi

if [[ "$code" -eq 0 ]]; then
  grep -E 'collected |[0-9]+ passed|[0-9]+ failed|PASSED$|FAILED|PASS=|FAIL=' "$LOG_FILE" | tail -n 20 || true
else
  tail -n 120 "$LOG_FILE"
fi

echo "PROBE_EXIT=$code"
exit "$code"
