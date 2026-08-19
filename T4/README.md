# EDAthon2026 T4 prep pack: P4 ASAP7 Polygon DRC repair

This pack makes P4 repeatable: prepare a case, summarize the DRC report, open
OpenCode, paste one prompt, run quick checks, run full local ASAP7 DRC, then sync/status.

## Install location

Host copy:

```text
D:\EDAthon2026\EDAthon2026prepare\T4
```

Installed workspace files:

```text
/workspace/p4_cases.sh
/workspace/p4_env_check.sh
/workspace/p4_prepare_case.sh
/workspace/p4_summary_case.sh
/workspace/p4_prompt_for_case.sh
/workspace/p4_eval_case.sh
/workspace/p4_full_drc_case.sh
/workspace/toolkit/skills/edathon-p4-fast/SKILL.md
```

## Install

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\EDAthon2026\EDAthon2026prepare\T4\install_to_workspace.ps1" -WorkspacePath "D:\edathon-problems-toolkit-20260819"
```

Inside the container:

```bash
bash /workspace/p4_env_check.sh
bash /workspace/p4_cases.sh
```

## Run one case

```bash
cd /workspace
bash /workspace/p4_prepare_case.sh Polygon117
cd /workspace/work/opencode_cases/P4/Polygon117
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p4_summary_case.sh Polygon117
bash /workspace/p4_prompt_for_case.sh Polygon117
```

Paste the printed prompt into OpenCode.

After OpenCode edits:

```bash
bash /workspace/p4_eval_case.sh Polygon117 quick
TIMEOUT_SEC=900 bash /workspace/p4_eval_case.sh Polygon117 full
bash /workspace/p4_eval_case.sh Polygon117 status
```
