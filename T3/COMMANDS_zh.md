# T3 / P3 命令大全

## PowerShell：启动一个比赛 workspace 容器

如果容器名/镜像名和你本地一致：

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

如果已有容器在跑：

```powershell
docker ps
docker exec -it edathon-t3 bash
```

## PowerShell：安装 T3 harness

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\EDAthon2026\EDAthon2026prepare\T3\install_to_workspace.ps1" -WorkspacePath "D:\edathon-problems-toolkit-20260819"
```

## 容器内：检查环境

```bash
cd /workspace
bash /workspace/p3_env_check.sh
bash /workspace/p3_cases.sh
```

## 容器内：准备并打开一个 case

```bash
cd /workspace
bash /workspace/p3_prepare_case.sh CAN-Bus
cd /workspace/work/opencode_cases/P3/CAN-Bus
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p3_prompt_for_case.sh CAN-Bus
```

复制最后一条输出的完整 prompt 给 OpenCode。

## 容器内：OpenCode 改完后的三种检查

无官方 ORFS bundle 也能跑：

```bash
bash /workspace/p3_eval_case.sh CAN-Bus struct
```

有官方 ORFS bundle 时，跑 placement smoke：

```bash
export CHIPBENCH_ORFS_FLOW_DIR=/official-bundle/flow
export CHIPBENCH_DESIGN_HOME=/official-bundle/designs
TIMEOUT_SEC=1800 bash /workspace/p3_eval_case.sh CAN-Bus place
```

有官方 ORFS bundle 且时间允许时，跑完整 downstream smoke：

```bash
export CHIPBENCH_ORFS_FLOW_DIR=/official-bundle/flow
export CHIPBENCH_DESIGN_HOME=/official-bundle/designs
TIMEOUT_SEC=3600 bash /workspace/p3_eval_case.sh CAN-Bus full
```

同步到 submission 并做官方提交格式检查：

```bash
bash /workspace/p3_eval_case.sh CAN-Bus status
```

如果你确认某个 case 的 Tcl 想作为全局默认：

```bash
bash /workspace/p3_sync_global.sh CAN-Bus
```

## 换 case

把 `CAN-Bus` 替换成：

```text
CAN-Bus
iot_shield
serv
DE2_CCD_edge
picorv32
sha256
```
