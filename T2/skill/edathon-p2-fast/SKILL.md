---
name: edathon-p2-fast
description: Fast, contest-safe workflow for EDAthon 2026 P2 RTL PPA optimization cases using candidate.v, public correctness, and Yosys mapped-area checks.
---

# EDAthon P2 fast PPA workflow

Use this skill only inside `/workspace/work/opencode_cases/P2/<case_id>`.

Read, in order:

1. `OPENCODE_TASK.md`
2. `prompt.txt`
3. `header.v`
4. `unopt.v`
5. `testbench.v`
6. `candidate.v`
7. `/workspace/problems/P2/README_zh.md`
8. `/workspace/problems/P2/SCORING_zh.md`

Do not edit `/workspace/problems/**/data`. Edit only `candidate.v`.

Hard requirements:

- `candidate.v` must define `module opt_model`;
- ports must exactly match `header.v`;
- helper modules must be in the same file;
- helper names must not collide with `unopt_model` or testbench modules;
- correctness is the hard gate.

Fast loop:

```bash
bash /workspace/p2_eval_case.sh <case_id> fast
```

Only compare area when correctness passes. For a JSON view:

```bash
bash /workspace/p2_eval_case.sh <case_id> json
```

When satisfied:

```bash
bash /workspace/p2_eval_case.sh <case_id> status
```

Prefer one small semantic-preserving optimization per iteration: constant
propagation, mux/decode simplification, Boolean factoring, shared arithmetic,
dead logic removal, register/wire cleanup, and operator-width cleanup. Keep a
known-correct candidate before attempting riskier rewrites. Public mapped area
is a proxy, not the official hidden PPA score.
