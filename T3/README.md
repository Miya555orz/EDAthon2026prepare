# EDAthon2026 T3 prep pack: P3 global placement

This pack makes P3 repeatable: prepare case, open OpenCode, paste one prompt,
run a fixed harness, sync, and run the official submission-format check.

## Install location

Host copy:

```text
D:\EDAthon2026\EDAthon2026prepare\T3
```

Installed workspace files:

```text
/workspace/p3_cases.sh
/workspace/p3_env_check.sh
/workspace/p3_prepare_case.sh
/workspace/p3_prompt_for_case.sh
/workspace/p3_eval_case.sh
/workspace/p3_sync_global.sh
/workspace/toolkit/skills/edathon-p3-fast/SKILL.md
```

## Install

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\EDAthon2026\EDAthon2026prepare\T3\install_to_workspace.ps1" -WorkspacePath "D:\edathon-problems-toolkit-20260819"
```

Inside the container:

```bash
bash /workspace/p3_env_check.sh
bash /workspace/p3_cases.sh
```

## Run one case

```bash
cd /workspace
bash /workspace/p3_prepare_case.sh CAN-Bus
cd /workspace/work/opencode_cases/P3/CAN-Bus
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p3_prompt_for_case.sh CAN-Bus
```

Paste the printed prompt into OpenCode.

After OpenCode edits:

```bash
bash /workspace/p3_eval_case.sh CAN-Bus struct
python3 /workspace/toolkit/opencode_harness/edathon_harness.py sync
python3 /workspace/toolkit/tools/check.py --problem P3
```

With the official ORFS bundle:

```bash
export CHIPBENCH_ORFS_FLOW_DIR=/official-bundle/flow
export CHIPBENCH_DESIGN_HOME=/official-bundle/designs
TIMEOUT_SEC=1800 bash /workspace/p3_eval_case.sh CAN-Bus place
```

Full downstream smoke, slow:

```bash
TIMEOUT_SEC=3600 bash /workspace/p3_eval_case.sh CAN-Bus full
```
