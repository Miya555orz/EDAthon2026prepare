---
name: edathon-p4-fast
description: Fast, contest-safe workflow for EDAthon 2026 P4 ASAP7 Polygon DRC repair cases using robust local structural/GDS checks and official submission sync.
---

# EDAthon P4 fast DRC-repair workflow

Use this skill only inside `/workspace/work/opencode_cases/P4/<case_id>`.

Read, in order:

1. `OPENCODE_TASK.md`
2. `drc_report.json`
3. `<case_id>_repaired.py`
4. relevant `screenshots/*`
5. `/workspace/problems/P4/README_zh.md`
6. `/workspace/problems/P4/SCORING_zh.md`

Do not edit `/workspace/problems/**/data`. Edit only
`<case_id>_repaired.py` in the current workdir.

Hard invariants:

- keep top cell name;
- keep `layout.dbu = 0.00025`;
- keep original cell structure;
- keep original layer set;
- keep shape count per layer;
- only move or reshape existing polygons;
- do not delete shapes;
- do not add masking/dummy shapes to hide violations;
- write exactly `../gds/<case_id>.gds`.

Fast loop:

```bash
bash /workspace/p4_summary_case.sh <case_id>
bash /workspace/p4_eval_case.sh <case_id> quick
```

Before final sync, run the full local ASAP7 DRC deck when KLayout is available:

```bash
TIMEOUT_SEC=900 bash /workspace/p4_eval_case.sh <case_id> full
```

When satisfied:

```bash
bash /workspace/p4_eval_case.sh <case_id> status
```

Use the DRC report bbox/edge/vertices as the source of truth. Make the smallest
local coordinate change that satisfies the rule description. Avoid changing
unrelated polygons because hidden scoring requires zero final violations and
zero new violations. Public quick/status checks are weak proxies. Full local
ASAP7 DRC is a stronger proxy and should be used before treating a case as
likely clean, but the hidden official evaluator remains the source of truth.
