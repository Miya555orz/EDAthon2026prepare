# T3 / P3 command cookbook

## PowerShell: start a contest workspace container

```powershell
$Ws = "D:\edathon-problems-toolkit-20260819"
$Img = "edathon-openroad-tools:local"
docker run --rm -it `
  --name edathon-t3 `
  --mount "type=bind,source=$Ws,target=/workspace" `
  --workdir /workspace `
  $Img `
  bash
```

Attach to an existing container:

```powershell
docker ps
docker exec -it edathon-t3 bash
```

## Install T3 harness

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\EDAthon2026\EDAthon2026prepare\T3\install_to_workspace.ps1" -WorkspacePath "D:\edathon-problems-toolkit-20260819"
```

## Inside container

```bash
cd /workspace
bash /workspace/p3_env_check.sh
bash /workspace/p3_cases.sh
bash /workspace/p3_prepare_case.sh CAN-Bus
cd /workspace/work/opencode_cases/P3/CAN-Bus
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p3_prompt_for_case.sh CAN-Bus
```

After OpenCode edits:

```bash
bash /workspace/p3_eval_case.sh CAN-Bus struct
bash /workspace/p3_eval_case.sh CAN-Bus status
```

With the official ORFS bundle:

```bash
export CHIPBENCH_ORFS_FLOW_DIR=/official-bundle/flow
export CHIPBENCH_DESIGN_HOME=/official-bundle/designs
TIMEOUT_SEC=1800 bash /workspace/p3_eval_case.sh CAN-Bus place
TIMEOUT_SEC=3600 bash /workspace/p3_eval_case.sh CAN-Bus full
```
