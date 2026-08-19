#!/usr/bin/env bash
set -euo pipefail

CASE_ID="${1:-}"
MODE="${2:-struct}"
ROOT="${WORKSPACE_ROOT:-/workspace}"
TIMEOUT_SEC="${TIMEOUT_SEC:-900}"
WORKDIR="$ROOT/work/opencode_cases/P3/$CASE_ID"

if [[ -z "$CASE_ID" ]]; then
  echo "Usage: bash /workspace/p3_eval_case.sh <case_id> [struct|place|full|status]" >&2
  exit 2
fi

if [[ ! -d "$WORKDIR" ]]; then
  echo "INFO: workdir missing; preparing $CASE_ID first."
  bash "$ROOT/p3_prepare_case.sh" "$CASE_ID"
fi

case "$MODE" in
  struct)
    cd "$WORKDIR"
    python3 "$ROOT/toolkit/opencode_harness/edathon_harness.py" eval
    ;;
  place)
    if [[ -z "${CHIPBENCH_ORFS_FLOW_DIR:-}" || -z "${CHIPBENCH_DESIGN_HOME:-}" ]]; then
      echo "ERROR: place mode requires official bundle env vars:" >&2
      echo "  export CHIPBENCH_ORFS_FLOW_DIR=/official-bundle/flow" >&2
      echo "  export CHIPBENCH_DESIGN_HOME=/official-bundle/designs" >&2
      exit 2
    fi
    cd "$WORKDIR"
    python3 "$ROOT/toolkit/opencode_harness/edathon_harness.py" eval \
      --flow-dir "$CHIPBENCH_ORFS_FLOW_DIR" \
      --design-home "$CHIPBENCH_DESIGN_HOME" \
      --stop-after global_place \
      --timeout "$TIMEOUT_SEC"
    ;;
  full)
    if [[ -z "${CHIPBENCH_ORFS_FLOW_DIR:-}" || -z "${CHIPBENCH_DESIGN_HOME:-}" ]]; then
      echo "ERROR: full mode requires official bundle env vars:" >&2
      echo "  export CHIPBENCH_ORFS_FLOW_DIR=/official-bundle/flow" >&2
      echo "  export CHIPBENCH_DESIGN_HOME=/official-bundle/designs" >&2
      exit 2
    fi
    python3 "$ROOT/problems/P3/utils/run_case.py" \
      --case "$CASE_ID" \
      --global-place-script "$WORKDIR/global_place.tcl" \
      --flow-dir "$CHIPBENCH_ORFS_FLOW_DIR" \
      --design-home "$CHIPBENCH_DESIGN_HOME" \
      --run-root "$ROOT/work/p3-public-run" \
      --timeout "$TIMEOUT_SEC"
    ;;
  status)
    cd "$WORKDIR"
    python3 "$ROOT/toolkit/opencode_harness/edathon_harness.py" sync
    python3 "$ROOT/toolkit/tools/check.py" --problem P3
    ;;
  *)
    echo "Usage: bash /workspace/p3_eval_case.sh <case_id> [struct|place|full|status]" >&2
    exit 2
    ;;
esac
