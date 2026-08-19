#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-/workspace}"
CASE_FILE="$ROOT/problems/P2/case_ids.txt"

if [[ ! -f "$CASE_FILE" ]]; then
  echo "ERROR: missing $CASE_FILE" >&2
  exit 2
fi

nl -ba "$CASE_FILE"
