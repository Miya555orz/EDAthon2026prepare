# T4 / P4 command cookbook

## PowerShell: start a contest workspace container

```powershell
$Ws = "D:\edathon-problems-toolkit-20260819"
$Img = "edathon-openroad-tools:local"
docker run --rm -it `
  --name edathon-t4 `
  --mount "type=bind,source=$Ws,target=/workspace" `
  --workdir /workspace `
  $Img `
  bash
```

Attach to an existing container:

```powershell
docker ps
docker exec -it edathon-t4 bash
```

## Install T4 harness

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\EDAthon2026\EDAthon2026prepare\T4\install_to_workspace.ps1" -WorkspacePath "D:\edathon-problems-toolkit-20260819"
```

## Inside container

```bash
cd /workspace
bash /workspace/p4_env_check.sh
bash /workspace/p4_cases.sh
bash /workspace/p4_prepare_case.sh Polygon117
cd /workspace/work/opencode_cases/P4/Polygon117
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p4_summary_case.sh Polygon117
bash /workspace/p4_prompt_for_case.sh Polygon117
```

After OpenCode edits:

```bash
bash /workspace/p4_eval_case.sh Polygon117 quick
TIMEOUT_SEC=900 bash /workspace/p4_eval_case.sh Polygon117 full
bash /workspace/p4_eval_case.sh Polygon117 status
```

Optional official-harness comparison:

```bash
bash /workspace/p4_eval_case.sh Polygon117 official-eval
```
