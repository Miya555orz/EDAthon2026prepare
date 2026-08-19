You are solving EDAthon2026 P2 RTL PPA optimization, case_id=<CASE_ID>. Use the edathon-p2-fast skill.

Current workdir should be /workspace/work/opencode_cases/P2/<CASE_ID>.
Do not modify /workspace/problems/**/data.
Edit only candidate.v.

Hard requirements:
- candidate.v must define module opt_model
- ports must exactly match header.v
- helper modules must be in the same file and must not collide with unopt_model or testbench modules
- correctness is the hard gate; do not discuss area when correctness.ok=false

Read OPENCODE_TASK.md, prompt.txt, header.v, unopt.v, testbench.v, candidate.v, /workspace/problems/P2/README_zh.md, and /workspace/problems/P2/SCORING_zh.md.

Fixed loop:
1. Make one semantic-preserving optimization per iteration.
2. bash /workspace/p2_eval_case.sh <CASE_ID> fast
3. Continue area optimization only when fast returns 0 and correctness.ok=true.
4. When satisfied:
   bash /workspace/p2_eval_case.sh <CASE_ID> status

Do not sweep many versions, do not rewrite the evaluator, and do not go silent for more than 3 minutes.

Final report: case_id, candidate.v changes, correctness.ok, public mapped area/baseline area, fast/status exit codes, and note that public area is not the full official hidden PPA score.
