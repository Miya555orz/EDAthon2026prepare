---
name: edathon-p1-fast
description: Use for EDAthon P1 RTL completion cases to iterate quickly with the provided init/probe/full harness while editing only official submission target RTL files.
---

# EDAthon P1 Fast RTL Completion

Work from `/workspace`. Official frozen P1 cases are under `/workspace/problems/P1/data/cases/`; final P1 answers go only under `/workspace/submission/P1/<case_id>/<target_path>`.

Never modify `/workspace/problems/**`, public testbench files, `metadata.json`, `prompt.md`, `run_direct.sh`, or the P1 harness scripts in `/workspace`. Edit only the RTL files listed in the case `metadata.json:target_files`, copied into the matching path under `/workspace/submission/P1/<case_id>/`.

## Fast Case Loop

For a case:

1. Initialize submission targets:

   ```bash
   bash /workspace/p1_init_case.sh <case_id>
   ```

2. Read the case `prompt.md`, `metadata.json`, starter target RTL, `code/src/.env`, `code/src/test_runner.py`, and the relevant public cocotb tests.

3. Iterate with the probe harness first:

   ```bash
   TIMEOUT_SEC=30 bash /workspace/p1_probe_case.sh <case_id>
   ```

   Exit `0` means the first collected public pytest node passed. Exit `1` means compile/sim/assert failure. Exit `124` or `137` means timeout/hang; treat it as a failing RTL attempt.

4. Only after probe passes, run the full public smoke test:

   ```bash
   TIMEOUT_SEC=240 bash /workspace/p1_full_case.sh <case_id>
   ```

5. After full pass, check official submission shape:

   ```bash
   cd /workspace/toolkit && python3 tools/status.py --problem P1 && python3 tools/check.py --problem P1
   ```

## Speed Rules

Do not run `gdb`, debug `vvp` internals, generate waveforms, or run unbounded pytest/vvp commands during ordinary iteration. Every simulation command must have `timeout`.

If a run hangs at `0.00ns`, suspect zero-time combinational loops or `always @*` self-retriggering. Simplify RTL and initialize all combinational temporaries instead of debugging the simulator.

Do not repeatedly run the full 10-test suite before the probe passes. Move to the next case if a hypothesis fails repeatedly and time is scarce.

## Reporting

Report the case id, changed submission RTL files, implementation approach, final probe/full commands, exit codes, and remaining ambiguity. Do not treat prose as proof; the harness exit code is the evidence.
