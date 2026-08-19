# EDAthon2026 T4 准备包：P4 ASAP7 Polygon DRC 修复

这套文件把 P4 做成固定流程：准备 case → 摘要 DRC report → 打开 OpenCode → 粘同一份 prompt → quick 检查 → full ASAP7 DRC → sync/status。

## 小白防呆启动步骤

PowerShell 启动本地 Docker：

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

如果容器已经开着：

```powershell
docker exec -it edathon-t4 bash
```

容器内：

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

把 prompt 粘给 OpenCode。OpenCode 完成后：

```bash
bash /workspace/p4_eval_case.sh Polygon117 quick
TIMEOUT_SEC=900 bash /workspace/p4_eval_case.sh Polygon117 full
bash /workspace/p4_eval_case.sh Polygon117 status
```

P4 最常见错误：没写 `layout.write("../gds/<case>.gds")`，或者增删了 shape。quick 只是早测，full DRC 过了才比较安心。

## 需要放到哪里

宿主机保存位置：

```text
D:\EDAthon2026\EDAthon2026prepare\T4
```

赛场 workspace 里应安装成：

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

## 一次性安装

PowerShell：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\EDAthon2026\EDAthon2026prepare\T4\install_to_workspace.ps1" -WorkspacePath "D:\edathon-problems-toolkit-20260819"
```

容器内检查：

```bash
bash /workspace/p4_env_check.sh
bash /workspace/p4_cases.sh
```

## 跑一个 P4 case

```bash
cd /workspace
bash /workspace/p4_prepare_case.sh Polygon117
cd /workspace/work/opencode_cases/P4/Polygon117
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p4_summary_case.sh Polygon117
bash /workspace/p4_prompt_for_case.sh Polygon117
```

把输出 prompt 整段粘给 OpenCode。

OpenCode 修完后：

```bash
bash /workspace/p4_eval_case.sh Polygon117 quick
TIMEOUT_SEC=900 bash /workspace/p4_eval_case.sh Polygon117 full
bash /workspace/p4_eval_case.sh Polygon117 status
```

## 三种检查的含义

- `quick`：鲁棒结构检查；如果环境有 `klayout`，还会 staged 执行脚本并确认生成 `../gds/<case>.gds`。
- `full`：生成 GDS 后调用 `problems/P4/data/asap7.lydrc` 跑完整本地 DRC deck，违例数为 0 才返回 0。
- `official-eval`：调用官方 `edathon_harness.py eval`；保留作对照，但它的 P4 字符串检查较脆。
- `status`：sync 到 `submission/P4/cases/<case>_repaired.py`，然后跑 `python3 /workspace/toolkit/tools/check.py --problem P4`。

## 常见故障

- `klayout not on PATH`：还能做结构检查，但不能本地生成 GDS；正式比赛容器通常应有 KLayout。
- `writes_required_gds=false`：确认脚本里是 `layout.write("../gds/Polygon117.gds")`，路径和 case 名必须完全对应。
- `full/status` 过了仍不等于官方 clean pass：hidden evaluator 才是最终分。但 full DRC 是比 quick/status 强很多的本地正确率保障。
