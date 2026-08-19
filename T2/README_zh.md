# EDAthon2026 T2 准备包：P2 RTL PPA 优化

这套文件把 P2 做成固定流程：准备 case → 打开 OpenCode → 粘同一份 prompt → fast eval → sync/status。

## 小白防呆启动步骤

PowerShell 启动本地 Docker：

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

如果容器已经开着：

```powershell
docker exec -it edathon-t2 bash
```

容器内打开 OpenCode 前：

```bash
cd /workspace
bash /workspace/p2_env_check.sh
bash /workspace/p2_cases.sh
bash /workspace/p2_prepare_case.sh int_sqrt2
cd /workspace/work/opencode_cases/P2/int_sqrt2
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p2_prompt_for_case.sh int_sqrt2
```

把 prompt 粘给 OpenCode。OpenCode 完成后：

```bash
bash /workspace/p2_eval_case.sh int_sqrt2 fast
bash /workspace/p2_eval_case.sh int_sqrt2 json
bash /workspace/p2_eval_case.sh int_sqrt2 status
```

P2 最常见错误：`candidate.v` 里没有 `module opt_model`，或者端口和 `header.v` 不一致。correctness 没过时不要看 area。

## 安装位置

宿主机保存位置：

```text
D:\EDAthon2026\EDAthon2026prepare\T2
```

赛场 workspace 里应安装成：

```text
/workspace/p2_cases.sh
/workspace/p2_env_check.sh
/workspace/p2_prepare_case.sh
/workspace/p2_prompt_for_case.sh
/workspace/p2_eval_case.sh
/workspace/toolkit/skills/edathon-p2-fast/SKILL.md
```

## 一次性安装

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\EDAthon2026\EDAthon2026prepare\T2\install_to_workspace.ps1" -WorkspacePath "D:\edathon-problems-toolkit-20260819"
```

## 容器内检查

```bash
cd /workspace
bash /workspace/p2_env_check.sh
bash /workspace/p2_cases.sh
```

## 跑一个 case

```bash
cd /workspace
bash /workspace/p2_prepare_case.sh Prob021_mux256to1v
cd /workspace/work/opencode_cases/P2/Prob021_mux256to1v
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p2_prompt_for_case.sh Prob021_mux256to1v
```

把输出 prompt 整段粘给 OpenCode。

OpenCode 改完后：

```bash
bash /workspace/p2_eval_case.sh Prob021_mux256to1v fast
bash /workspace/p2_eval_case.sh Prob021_mux256to1v status
```

需要看 JSON：

```bash
bash /workspace/p2_eval_case.sh Prob021_mux256to1v json
```

## 注意

correctness 是硬门槛。公开 Yosys mapped area 只是 proxy，不是官方完整 area/delay/power hidden score。
