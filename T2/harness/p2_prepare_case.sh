#!/usr/bin/env bash
set -euo pipefail

CASE_ID="${1:-}"
FORCE="${2:-}"
ROOT="${WORKSPACE_ROOT:-/workspace}"

if [[ -z "$CASE_ID" ]]; then
  echo "Usage: bash /workspace/p2_prepare_case.sh <case_id> [--force]" >&2
  bash "$ROOT/p2_cases.sh" "$ROOT" >&2 || true
  exit 2
fi

ARGS=(prepare P2 "$CASE_ID")
if [[ "$FORCE" == "--force" ]]; then
  ARGS+=(--force)
fi

cd "$ROOT"
python3 "$ROOT/toolkit/opencode_harness/edathon_harness.py" "${ARGS[@]}"

echo
echo "NEXT:"
echo "cd /workspace/work/opencode_cases/P2/$CASE_ID"
echo "bash /workspace/toolkit/opencode_harness/opencode_once.sh"
echo "bash /workspace/p2_prompt_for_case.sh $CASE_ID"
