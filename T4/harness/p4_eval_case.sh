#!/usr/bin/env bash
set -euo pipefail

CASE_ID="${1:-}"
MODE="${2:-quick}"
ROOT="${WORKSPACE_ROOT:-/workspace}"
WORKDIR="$ROOT/work/opencode_cases/P4/$CASE_ID"
SCRIPT="$WORKDIR/${CASE_ID}_repaired.py"

if [[ -z "$CASE_ID" ]]; then
  echo "Usage: bash /workspace/p4_eval_case.sh <case_id> [quick|official-eval|status]" >&2
  exit 2
fi

if [[ ! -d "$WORKDIR" ]]; then
  echo "INFO: workdir missing; preparing $CASE_ID first."
  bash "$ROOT/p4_prepare_case.sh" "$CASE_ID"
fi

if [[ ! -f "$SCRIPT" && -f "$WORKDIR/repaired.py" ]]; then
  SCRIPT="$WORKDIR/repaired.py"
fi

case "$MODE" in
  quick)
    if [[ ! -f "$SCRIPT" ]]; then
      echo "ERROR: missing repaired script: $SCRIPT" >&2
      exit 2
    fi
    python3 - "$CASE_ID" "$SCRIPT" <<'PY'
import json
import re
import sys
from pathlib import Path

case = sys.argv[1]
script = Path(sys.argv[2])
text = script.read_text(encoding="utf-8", errors="ignore")
compact = re.sub(r"\s+", "", text)
checks = {
    "imports_pya": bool(re.search(r"(^|\n)\s*import\s+pya\b", text)),
    "sets_dbu_0p00025": "layout.dbu=0.00025" in compact,
    "writes_required_gds": bool(re.search(r"layout\.write\(\s*['\"]\.\./gds/" + re.escape(case) + r"\.gds['\"]\s*\)", text)),
    "mentions_no_external_case_read": "/workspace/problems/P4/data/cases" not in text.replace("\\", "/"),
}
print(json.dumps({"p4_fast_structural_check": checks, "official_drc": "not available in public package"}, indent=2))
if not all(checks.values()):
    sys.exit(1)
PY
    if command -v klayout >/dev/null 2>&1; then
      TMP="$(mktemp -d)"
      mkdir -p "$TMP/scripts" "$TMP/gds"
      cp "$SCRIPT" "$TMP/scripts/$(basename "$SCRIPT")"
      (cd "$TMP/scripts" && timeout "${TIMEOUT_SEC:-120}" klayout -b -r "$(basename "$SCRIPT")")
      test -f "$TMP/gds/$CASE_ID.gds"
      echo "P4_QUICK_GDS_OK: $TMP/gds/$CASE_ID.gds"
    else
      echo "WARN: klayout missing; skipped GDS generation."
    fi
    echo "P4_QUICK_EXIT=0"
    ;;
  official-eval)
    cd "$WORKDIR"
    python3 "$ROOT/toolkit/opencode_harness/edathon_harness.py" eval
    ;;
  full)
    bash "$ROOT/p4_full_drc_case.sh" "$CASE_ID"
    ;;
  status)
    cd "$WORKDIR"
    python3 "$ROOT/toolkit/opencode_harness/edathon_harness.py" sync
    python3 "$ROOT/toolkit/tools/check.py" --problem P4
    ;;
  *)
    echo "Usage: bash /workspace/p4_eval_case.sh <case_id> [quick|full|official-eval|status]" >&2
    exit 2
    ;;
esac
