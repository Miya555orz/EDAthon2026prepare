---
name: edathon-p3-fast
description: Fast, contest-safe workflow for EDAthon 2026 P3 global placement Tcl cases using the official toolkit harness plus optional ORFS placement/full checks.
---

# EDAthon P3 fast placement workflow

Use this skill only inside `/workspace/work/opencode_cases/P3/<case_id>`.

Read, in order:

1. `OPENCODE_TASK.md`
2. `README_INPUTS.md`
3. `RUN_P3.md`
4. `/workspace/problems/P3/README_zh.md`
5. `/workspace/problems/P3/SCORING_zh.md`
6. `global_place.tcl`

Do not edit `/workspace/problems/**/data`. Edit only the current workdir
`global_place.tcl` until checks pass.

The submitted file must be a complete ORFS `global_place` stage replacement:

- source/load the normal ORFS stage environment;
- `load_design 3_2_place_iop.odb 2_floorplan.sdc`;
- perform standard-cell global placement;
- preserve top design, die/core, macro placement, and IO placement;
- write `$::env(RESULTS_DIR)/3_3_place_gp.odb`.

Fast loop:

```bash
bash /workspace/p3_eval_case.sh <case_id> struct
```

If the official ORFS bundle is mounted and the environment variables are set:

```bash
bash /workspace/p3_eval_case.sh <case_id> place
```

For downstream smoke, only when time allows:

```bash
TIMEOUT_SEC=3600 bash /workspace/p3_eval_case.sh <case_id> full
```

When satisfied:

```bash
cd /workspace/work/opencode_cases/P3/<case_id>
python3 /workspace/toolkit/opencode_harness/edathon_harness.py sync
python3 /workspace/toolkit/tools/check.py --problem P3
```

Prefer conservative changes: tune density, padding, timing/routability switches,
or `GLOBAL_PLACEMENT_ARGS`. Keep `fast_route`, metrics reporting, and final
`write_db`. A structural check is not official score; HPWL feedback is not final
score. Final score depends on downstream route, timing, power, and legality.
