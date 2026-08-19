#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CASE_ID="${1:-}"

if [[ -z "$CASE_ID" ]]; then
  echo "Usage: bash p1_init_case.sh <case_id>" >&2
  exit 2
fi

CASE_DIR="$ROOT_DIR/problems/P1/data/cases/$CASE_ID"
SUB_DIR="$ROOT_DIR/submission/P1/$CASE_ID"

if [[ ! -d "$CASE_DIR" ]]; then
  echo "ERROR: unknown P1 case: $CASE_ID" >&2
  exit 2
fi

python3 - "$CASE_DIR" "$SUB_DIR" <<'PY'
import json
import shutil
import sys
from pathlib import Path

case_dir = Path(sys.argv[1])
sub_dir = Path(sys.argv[2])
meta = json.loads((case_dir / "metadata.json").read_text(encoding="utf-8"))
targets = meta.get("target_files")

if not isinstance(targets, list) or not targets:
    raise SystemExit("ERROR: metadata.json has no target_files list")

created = []
kept = []
for rel in targets:
    src = case_dir / "code" / rel
    dst = sub_dir / rel
    if not src.is_file():
        raise SystemExit(f"ERROR: starter target not found: {src}")
    dst.parent.mkdir(parents=True, exist_ok=True)
    if dst.exists():
        kept.append(rel)
    else:
        shutil.copy2(src, dst)
        created.append(rel)

print(f"case: {case_dir.name}")
for rel in created:
    print(f"created: submission/P1/{case_dir.name}/{rel}")
for rel in kept:
    print(f"kept: submission/P1/{case_dir.name}/{rel}")
PY
