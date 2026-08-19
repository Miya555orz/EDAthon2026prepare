# EDAthon2026 T3 准备包：P3 global placement

这套文件的目标是把 P3 做成和 T1 一样的固定流程：准备 case → 打开 OpenCode → 粘同一份 prompt → 跑固定 harness → sync → 官方提交格式检查。

## 小白防呆启动步骤

PowerShell 启动本地 Docker：

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

如果容器已经开着：

```powershell
docker exec -it edathon-t3 bash
```

容器内：

```bash
cd /workspace
bash /workspace/p3_env_check.sh
bash /workspace/p3_cases.sh
bash /workspace/p3_prepare_case.sh CAN-Bus
cd /workspace/work/opencode_cases/P3/CAN-Bus
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p3_prompt_for_case.sh CAN-Bus
```

把 prompt 粘给 OpenCode。OpenCode 完成后先跑快检查：

```bash
bash /workspace/p3_eval_case.sh CAN-Bus struct
bash /workspace/p3_eval_case.sh CAN-Bus status
```

如果官方 ORFS bundle 可用，再跑真 placement smoke：

```bash
export CHIPBENCH_ORFS_FLOW_DIR=/official-bundle/flow
export CHIPBENCH_DESIGN_HOME=/official-bundle/designs
TIMEOUT_SEC=1800 bash /workspace/p3_eval_case.sh CAN-Bus place
```

P3 最常见错误：只写 Tcl 片段，而不是完整 `global_place.tcl` stage。`struct/status` 不是性能分，只是可评分/结构检查。

## 需要放到哪里

在宿主机保存位置：

```text
D:\EDAthon2026\EDAthon2026prepare\T3
```

赛场 workspace 里应安装成：

```text
/workspace/p3_cases.sh
/workspace/p3_env_check.sh
/workspace/p3_prepare_case.sh
/workspace/p3_prompt_for_case.sh
/workspace/p3_eval_case.sh
/workspace/p3_sync_global.sh
/workspace/toolkit/skills/edathon-p3-fast/SKILL.md
```

## 一次性安装

PowerShell：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\EDAthon2026\EDAthon2026prepare\T3\install_to_workspace.ps1" -WorkspacePath "D:\edathon-problems-toolkit-20260819"
```

容器内检查：

```bash
bash /workspace/p3_env_check.sh
bash /workspace/p3_cases.sh
```

## 跑一个 P3 case

```bash
cd /workspace
bash /workspace/p3_prepare_case.sh CAN-Bus
cd /workspace/work/opencode_cases/P3/CAN-Bus
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p3_prompt_for_case.sh CAN-Bus
```

把输出 prompt 整段粘给 OpenCode。

OpenCode 修完后：

```bash
bash /workspace/p3_eval_case.sh CAN-Bus struct
python3 /workspace/toolkit/opencode_harness/edathon_harness.py sync
python3 /workspace/toolkit/tools/check.py --problem P3
```

如果官方 ORFS bundle 可用：

```bash
export CHIPBENCH_ORFS_FLOW_DIR=/official-bundle/flow
export CHIPBENCH_DESIGN_HOME=/official-bundle/designs
TIMEOUT_SEC=1800 bash /workspace/p3_eval_case.sh CAN-Bus place
```

完整下游 smoke（慢，只有时间允许才跑）：

```bash
TIMEOUT_SEC=3600 bash /workspace/p3_eval_case.sh CAN-Bus full
```

## 常见故障

- `struct` 过了但 `place/full` 不能跑：通常是没有官方 ORFS bundle，或 `CHIPBENCH_ORFS_FLOW_DIR` / `CHIPBENCH_DESIGN_HOME` 没设。
- `OpenROAD version mismatch`：说明不是官方指定 OpenROAD，正式环境必须用比赛容器。
- `status` 过了不等于高分：P3 最终分看下游 route/timing/power，公开包没有 hidden score。
