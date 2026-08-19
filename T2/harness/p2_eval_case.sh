#!/usr/bin/env bash
set -euo pipefail

CASE_ID="${1:-}"
MODE="${2:-fast}"
ROOT="${WORKSPACE_ROOT:-/workspace}"
WORKDIR="$ROOT/work/opencode_cases/P2/$CASE_ID"

if [[ -z "$CASE_ID" ]]; then
  echo "Usage: bash /workspace/p2_eval_case.sh <case_id> [fast|status|json]" >&2
  exit 2
fi

if [[ ! -d "$WORKDIR" ]]; then
  echo "INFO: workdir missing; preparing $CASE_ID first."
  bash "$ROOT/p2_prepare_case.sh" "$CASE_ID"
fi

case "$MODE" in
  fast)
    cd "$WORKDIR"
    python3 "$ROOT/toolkit/opencode_harness/edathon_harness.py" eval
    ;;
  json)
    cd "$ROOT"
    python3 "$ROOT/problems/P2/utils/evaluate_pluto_case.py" \
      --case "$ROOT/problems/P2/data/cases/$CASE_ID" \
      --candidate "$WORKDIR/candidate.v" \
      --json
    ;;
  status)
    cd "$WORKDIR"
    python3 "$ROOT/toolkit/opencode_harness/edathon_harness.py" sync
    python3 "$ROOT/toolkit/tools/check.py" --problem P2
    ;;
  *)
    echo "Usage: bash /workspace/p2_eval_case.sh <case_id> [fast|status|json]" >&2
    exit 2
    ;;
esac
