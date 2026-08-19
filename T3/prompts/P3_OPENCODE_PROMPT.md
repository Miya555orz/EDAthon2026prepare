You are solving EDAthon2026 P3 global_place.tcl, case_id=<CASE_ID>. Use the edathon-p3-fast skill.

Hard limits:
- Current OpenCode workdir should be /workspace/work/opencode_cases/P3/<CASE_ID>.
- Do not modify /workspace/problems/**/data.
- Edit only global_place.tcl in the current directory, then sync after checks pass.
- The submission must be a complete ORFS global_place stage, not a Tcl fragment.
- It must load_design 3_2_place_iop.odb 2_floorplan.sdc, run standard-cell global_placement, and write_db $::env(RESULTS_DIR)/3_3_place_gp.odb.
- Do not alter macros, IO, die/core, or top design name. Do not submit ODB/SDC/logs/metrics.

Read OPENCODE_TASK.md, README_INPUTS.md, RUN_P3.md, /workspace/problems/P3/README_zh.md, /workspace/problems/P3/SCORING_zh.md, and global_place.tcl.

Fixed loop:
1. bash /workspace/p3_eval_case.sh <CASE_ID> struct
2. If the official ORFS bundle is available:
   export CHIPBENCH_ORFS_FLOW_DIR=/official-bundle/flow
   export CHIPBENCH_DESIGN_HOME=/official-bundle/designs
   bash /workspace/p3_eval_case.sh <CASE_ID> place
3. When passing:
   python3 /workspace/toolkit/opencode_harness/edathon_harness.py sync
   python3 /workspace/toolkit/tools/check.py --problem P3

Final report: case_id, strategy, changed file, struct/place/status commands and exit codes, and any remaining hidden-score risk.
