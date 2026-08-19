#!/usr/bin/env bash
set -euo pipefail

CASE_ID="${1:-}"
ROOT="${WORKSPACE_ROOT:-/workspace}"
WORKDIR="$ROOT/work/opencode_cases/P3/$CASE_ID"

if [[ -z "$CASE_ID" || ! -d "$WORKDIR" ]]; then
  echo "Usage: bash /workspace/p3_sync_global.sh <case_id>" >&2
  echo "This copies that case workdir global_place.tcl to submission/P3/global_place.tcl." >&2
  exit 2
fi

cd "$WORKDIR"
python3 "$ROOT/toolkit/opencode_harness/edathon_harness.py" sync --global-script
python3 "$ROOT/toolkit/tools/check.py" --problem P3
