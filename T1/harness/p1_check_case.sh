#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CASE_ID="${1:-}"

if [[ -z "$CASE_ID" ]]; then
  echo "Usage: bash p1_check_case.sh <case_id>" >&2
  exit 2
fi

PROBLEM_DIR="$ROOT_DIR/problems/P1"
CASE_SRC="$PROBLEM_DIR/data/cases/$CASE_ID"
SUB_CASE="$ROOT_DIR/submission/P1/$CASE_ID"

if [[ ! -d "$CASE_SRC" ]]; then
  echo "ERROR: unknown P1 case: $CASE_ID" >&2
  echo "Hint: see $PROBLEM_DIR/case_ids.txt" >&2
  exit 2
fi

if [[ -n "${WORKDIR_BASE:-}" ]]; then
  mkdir -p "$WORKDIR_BASE"
  WORKDIR="$(mktemp -d "$WORKDIR_BASE/p1_${CASE_ID}_XXXXXX")"
else
  WORKDIR="$(mktemp -d "/tmp/p1_${CASE_ID}_XXXXXX")"
fi

cleanup() {
  code=$?
  if [[ "${KEEP_WORKDIR:-0}" == "1" || "$code" -ne 0 ]]; then
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

cd "$WORKDIR/case"
./run_direct.sh
