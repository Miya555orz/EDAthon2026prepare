#!/usr/bin/env bash
set -euo pipefail

CASE_ID="${1:-}"
ROOT="${WORKSPACE_ROOT:-/workspace}"
REPORT="$ROOT/problems/P4/data/cases/$CASE_ID/drc_report.json"

if [[ -z "$CASE_ID" || ! -f "$REPORT" ]]; then
  echo "Usage: bash /workspace/p4_summary_case.sh <case_id>" >&2
  exit 2
fi

python3 - "$REPORT" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
data = json.loads(path.read_text())
print(f"case_name: {data.get('case_name')}")
print(f"total_violations: {data.get('total_violations')}")
print(f"total_rules_violated: {data.get('total_rules_violated')}")
print()
for rule, info in data.get("rules", {}).items():
    print(f"[{rule}] count={info.get('violation_count')}")
    desc = info.get("description", "")
    if desc:
        print(f"  desc: {desc}")
    for idx, vio in enumerate(info.get("violations", []), 1):
        bbox = vio.get("bbox")
        vtype = vio.get("type")
        print(f"  #{idx}: type={vtype} bbox={bbox}")
        if "vertices" in vio:
            print(f"      vertices={vio['vertices']}")
        if "edges" in vio:
            print(f"      edges={vio['edges']}")
    print()
PY
