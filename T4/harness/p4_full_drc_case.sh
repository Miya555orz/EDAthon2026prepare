#!/usr/bin/env bash
set -euo pipefail

CASE_ID="${1:-}"
ROOT="${WORKSPACE_ROOT:-/workspace}"
TIMEOUT_SEC="${TIMEOUT_SEC:-900}"
WORKDIR="$ROOT/work/opencode_cases/P4/$CASE_ID"
SCRIPT="$WORKDIR/${CASE_ID}_repaired.py"
DRC_DECK="$ROOT/problems/P4/data/asap7.lydrc"

if [[ -z "$CASE_ID" ]]; then
  echo "Usage: TIMEOUT_SEC=900 bash /workspace/p4_full_drc_case.sh <case_id>" >&2
  exit 2
fi

if ! command -v klayout >/dev/null 2>&1; then
  echo "ERROR: klayout not found; cannot run full ASAP7 DRC deck." >&2
  exit 127
fi

if [[ ! -f "$SCRIPT" && -f "$WORKDIR/repaired.py" ]]; then
  SCRIPT="$WORKDIR/repaired.py"
fi
if [[ ! -f "$SCRIPT" ]]; then
  echo "ERROR: missing repaired script: $SCRIPT" >&2
  exit 2
fi
if [[ ! -f "$DRC_DECK" ]]; then
  echo "ERROR: missing DRC deck: $DRC_DECK" >&2
  exit 2
fi

TMP="$(mktemp -d)"
mkdir -p "$TMP/scripts" "$TMP/gds" "$TMP/reports"
cp "$SCRIPT" "$TMP/scripts/$(basename "$SCRIPT")"

echo "== Generate repaired GDS =="
(cd "$TMP/scripts" && timeout "$TIMEOUT_SEC" klayout -b -r "$(basename "$SCRIPT")")
GDS="$TMP/gds/$CASE_ID.gds"
if [[ ! -f "$GDS" ]]; then
  echo "ERROR: repaired script did not create $GDS" >&2
  exit 1
fi

REPORT="$TMP/reports/${CASE_ID}_asap7.lyrdb"
LOG="$TMP/reports/${CASE_ID}_asap7_drc.log"

echo "== Run full ASAP7 DRC deck =="
set +e
timeout "$TIMEOUT_SEC" klayout -b -r "$DRC_DECK" \
  -rd "in_gds=$GDS" \
  -rd "report_file=$REPORT" \
  >"$LOG" 2>&1
RC=$?
set -e

tail -80 "$LOG" || true

if [[ "$RC" -ne 0 ]]; then
  echo "P4_FULL_DRC_EXIT=$RC"
  echo "Report dir kept: $TMP/reports"
  exit "$RC"
fi

python3 - "$REPORT" <<'PY'
import re
import sys
from pathlib import Path

report = Path(sys.argv[1])
if not report.is_file():
    print(f"ERROR: missing DRC report {report}", file=sys.stderr)
    sys.exit(1)
text = report.read_text(encoding="utf-8", errors="ignore")
items = len(re.findall(r"<item\b", text))
print(f"P4_FULL_DRC_REPORT={report}")
print(f"P4_FULL_DRC_VIOLATIONS={items}")
if items:
    cats = re.findall(r"<category[^>]*>\s*<name>(.*?)</name>", text, flags=re.S)
    if cats:
        print("P4_FULL_DRC_CATEGORIES:")
        for cat in cats[:40]:
            print("  " + re.sub(r"\s+", " ", cat).strip())
    sys.exit(1)
PY

echo "P4_FULL_DRC_EXIT=0"
