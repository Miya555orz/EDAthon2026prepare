# T4 / P4 命令大全

## PowerShell：启动一个比赛 workspace 容器

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

如果已有容器在跑：

```powershell
docker ps
docker exec -it edathon-t4 bash
```

## PowerShell：安装 T4 harness

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\EDAthon2026\EDAthon2026prepare\T4\install_to_workspace.ps1" -WorkspacePath "D:\edathon-problems-toolkit-20260819"
```

## 容器内：检查环境

```bash
cd /workspace
bash /workspace/p4_env_check.sh
bash /workspace/p4_cases.sh
```

## 容器内：准备并打开一个 case

```bash
cd /workspace
bash /workspace/p4_prepare_case.sh Polygon117
cd /workspace/work/opencode_cases/P4/Polygon117
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p4_summary_case.sh Polygon117
bash /workspace/p4_prompt_for_case.sh Polygon117
```

复制最后一条输出的完整 prompt 给 OpenCode。

## 容器内：OpenCode 改完后的检查

快速结构/GDS 检查：

```bash
bash /workspace/p4_eval_case.sh Polygon117 quick
```

完整本地 ASAP7 DRC，推荐每题最终确认跑一次：

```bash
TIMEOUT_SEC=900 bash /workspace/p4_eval_case.sh Polygon117 full
```

官方 harness 对照检查：

```bash
bash /workspace/p4_eval_case.sh Polygon117 official-eval
```

同步到 submission 并做官方提交格式检查：

```bash
bash /workspace/p4_eval_case.sh Polygon117 status
```

## 换 case

先列出：

```bash
bash /workspace/p4_cases.sh
```

再把 `Polygon117` 替换成你要做的 case，例如 `Polygon9`。

## 注意

`quick/status` 不等于 clean pass。`full` 是更强的本地 proxy；P4 hidden 分数仍要求官方 final violations=0 且 new violations=0。
