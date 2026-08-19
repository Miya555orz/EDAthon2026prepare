# T2 / P2 命令大全

## PowerShell：安装

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\EDAthon2026\EDAthon2026prepare\T2\install_to_workspace.ps1" -WorkspacePath "D:\edathon-problems-toolkit-20260819"
```

## PowerShell：启动容器

```powershell
$Ws = "D:\edathon-problems-toolkit-20260819"
$Img = "edathon-openroad-tools:local"
docker run --rm -it `
  --name edathon-t2 `
  --mount "type=bind,source=$Ws,target=/workspace" `
  --workdir /workspace `
  $Img `
  bash
```

已有容器：

```powershell
docker exec -it edathon-t2 bash
```

## 容器内：准备、打开、粘 prompt

```bash
cd /workspace
bash /workspace/p2_env_check.sh
bash /workspace/p2_cases.sh
bash /workspace/p2_prepare_case.sh Prob021_mux256to1v
cd /workspace/work/opencode_cases/P2/Prob021_mux256to1v
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p2_prompt_for_case.sh Prob021_mux256to1v
```

## 容器内：检查

```bash
bash /workspace/p2_eval_case.sh Prob021_mux256to1v fast
bash /workspace/p2_eval_case.sh Prob021_mux256to1v json
bash /workspace/p2_eval_case.sh Prob021_mux256to1v status
```
