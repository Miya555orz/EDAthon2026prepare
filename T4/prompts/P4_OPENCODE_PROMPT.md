You are solving EDAthon2026 P4 ASAP7 Polygon DRC repair, case_id=<CASE_ID>. Use the edathon-p4-fast skill.

Hard limits:
- Current OpenCode workdir should be /workspace/work/opencode_cases/P4/<CASE_ID>.
- Do not modify /workspace/problems/**/data.
- Edit only <CASE_ID>_repaired.py in the current directory.
- Only move or reshape existing polygons; do not delete shapes and do not add masking shapes.
- Preserve top cell name, layout.dbu=0.00025, cell structure, original layer set, and per-layer shape count.
- The script must write layout.write("../gds/<CASE_ID>.gds").
- Do not submit GDS, screenshots, or DRC reports.

Read OPENCODE_TASK.md, drc_report.json, <CASE_ID>_repaired.py, screenshots/, /workspace/problems/P4/README_zh.md, and /workspace/problems/P4/SCORING_zh.md.

Fast case summary:
  bash /workspace/p4_summary_case.sh <CASE_ID>

Fixed loop:
1. bash /workspace/p4_eval_case.sh <CASE_ID> quick
2. When quick passes, run the full local ASAP7 DRC deck:
   TIMEOUT_SEC=900 bash /workspace/p4_eval_case.sh <CASE_ID> full
3. When full DRC returns 0:
   bash /workspace/p4_eval_case.sh <CASE_ID> status

Final report: case_id, changed polygons/coordinates/bboxes, preserved invariants, quick/full/status commands and exit codes, full DRC violation count, and hidden DRC risk.
