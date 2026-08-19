#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CASE_ID="${1:-}"

if [[ -z "$CASE_ID" ]]; then
  echo "Usage: bash p1_prompt_for_case.sh <case_id>" >&2
  exit 2
fi

if [[ ! -d "$ROOT_DIR/problems/P1/data/cases/$CASE_ID" ]]; then
  echo "ERROR: unknown P1 case: $CASE_ID" >&2
  exit 2
fi

cat <<EOF
Use the edathon-p1-fast skill. If it is not auto-loaded, read and follow:
/workspace/toolkit/skills/edathon-p1-fast/SKILL.md

You are solving EDAthon 2026 P1 RTL code completion.

CASE_ID = $CASE_ID

Work from /workspace.

Official frozen case:
/workspace/problems/P1/data/cases/$CASE_ID/

Submission directory:
/workspace/submission/P1/$CASE_ID/

Follow this exact workflow:

1. Run:
   bash /workspace/p1_init_case.sh $CASE_ID

2. Read:
   /workspace/problems/P1/data/cases/$CASE_ID/prompt.md
   /workspace/problems/P1/data/cases/$CASE_ID/metadata.json
   /workspace/problems/P1/data/cases/$CASE_ID/code/src/.env
   /workspace/problems/P1/data/cases/$CASE_ID/code/src/test_runner.py
   the relevant public tests under /workspace/problems/P1/data/cases/$CASE_ID/code/src/
   the copied target RTL files under /workspace/submission/P1/$CASE_ID/

3. Edit only the copied target RTL files under:
   /workspace/submission/P1/$CASE_ID/

4. Iterate using only the fast probe first:
   TIMEOUT_SEC=30 bash /workspace/p1_probe_case.sh $CASE_ID
   echo "PROBE_EXIT=\$?"

5. If probe exits 0, run the full public smoke test:
   TIMEOUT_SEC=240 bash /workspace/p1_full_case.sh $CASE_ID
   echo "FULL_EXIT=\$?"

Rules:
- Do not modify anything under /workspace/problems/.
- Do not modify /workspace/p1_*.sh, metadata.json, prompt.md, code/src, or run_direct.sh.
- Do not run gdb or debug vvp internals.
- Do not run unbounded pytest/vvp commands; use timeout.
- If probe exits 124 or 137, treat it as a failing RTL attempt and simplify/fix RTL.
- Preserve module names, ports, parameters, widths, reset behavior, and timing.
- Do not hardcode visible test cases.
- Use simple synthesizable SystemVerilog.

Stop only when the full public smoke test exits 0.

Report:
- case_id
- changed submission RTL files
- implementation approach
- final probe and full commands
- exit codes
- remaining ambiguity
EOF
