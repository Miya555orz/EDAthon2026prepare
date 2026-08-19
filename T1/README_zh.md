# EDAthon 2026 P1 快速 Harness 包

这个文件夹只包含 P1 工作流辅助工具，不包含任何已解出的 RTL 答案。只有在比赛规则允许携带自备脚本/资料时才使用它。正式评分仍以官方容器中的 `/workspace/submission/P1/` 为准。

## 文件应该放在哪里

把这些脚本复制到 EDAthon workspace 根目录：

```text
T1/harness/p1_check_case.sh       -> /workspace/p1_check_case.sh
T1/harness/p1_check_case_fast.sh  -> /workspace/p1_check_case_fast.sh
T1/harness/p1_env_check.sh        -> /workspace/p1_env_check.sh
T1/harness/p1_init_case.sh        -> /workspace/p1_init_case.sh
T1/harness/p1_probe_case.sh       -> /workspace/p1_probe_case.sh
T1/harness/p1_full_case.sh        -> /workspace/p1_full_case.sh
T1/harness/p1_prompt_for_case.sh  -> /workspace/p1_prompt_for_case.sh
```

把 skill 放到：

```text
T1/skill/edathon-p1-fast/SKILL.md -> /workspace/toolkit/skills/edathon-p1-fast/SKILL.md
```

可选的本地镜像 Dockerfile 放到：

```text
T1/local-docker/Dockerfile.p1-cocotb -> /workspace/local-docker/Dockerfile.p1-cocotb
```

脚本默认官方题目树在：

```text
/workspace/problems/P1/data/cases/<case_id>/
```

答案只写到：

```text
/workspace/submission/P1/<case_id>/<target_path>
```

## 在 Windows 上安装到题包

如果你的题包在 Windows 路径，例如 `D:\edathon-problems-toolkit-20260819`，运行：

```powershell
$Pack = 'D:\EDAthon2026\EDAthon2026prepare\T1'
$Workspace = 'D:\edathon-problems-toolkit-20260819'

powershell -ExecutionPolicy Bypass -File "$Pack\install_to_workspace.ps1" -WorkspacePath $Workspace
```

如果已经在 Linux 容器里，并且这个 T1 包被挂载进去了：

```bash
bash /path/to/T1/install_to_workspace.sh /workspace
```

## 本地 Docker 命令

只有当前镜像缺 `pytest` 或 `cocotb` 时，才构建本地 P1 镜像：

```powershell
$Workspace = 'D:\edathon-problems-toolkit-20260819'

docker build `
  -f "$Workspace\local-docker\Dockerfile.p1-cocotb" `
  -t edathon-p1-cocotb:local `
  "$Workspace\local-docker"
```

启动一个新的本地容器：

```powershell
$Workspace = 'D:\edathon-problems-toolkit-20260819'

docker run -it `
  --name edathon-p1-local `
  --mount "type=bind,source=$Workspace,target=/workspace" `
  --workdir /workspace `
  edathon-p1-cocotb:local `
  bash
```

如果容器已经存在：

```powershell
docker start -ai edathon-p1-local
```

打开第二个 shell 进入正在运行的容器：

```powershell
docker exec -it edathon-p1-local bash
```

如果 OpenCode 或仿真卡住，从另一个 PowerShell 终止仿真：

```powershell
docker exec edathon-p1-local bash -lc "pkill -TERM -f 'pytest|vvp|/tmp/opencode/run_one.sh' || true"
```

检查容器内工具：

```bash
bash /workspace/p1_env_check.sh /workspace
```

等价的手工检查：

```bash
python3 - <<'PY'
import importlib.util
for m in ["pytest", "cocotb", "cocotb_tools.runner"]:
    print(m, "OK" if importlib.util.find_spec(m) else "MISSING")
PY
command -v iverilog
command -v vvp
```

如果 `p1_env_check.sh` 打印 `ENV_CHECK_FAIL`，比赛期间不要切换到外部 Docker 镜像。保留输出并联系主办方，因为 P1 的 `run_direct.sh` 需要这些 benchmark 依赖。如果规则明确允许在官方容器内安装包，只能使用主办方允许的命令；否则最多做 compile-only RTL 临时诊断，不能把它当作计分通过证据。

检查脚本语法：

```bash
bash -n /workspace/p1_init_case.sh \
  /workspace/p1_probe_case.sh \
  /workspace/p1_full_case.sh \
  /workspace/p1_prompt_for_case.sh
```

## 单题流程

选择一个 case：

```bash
cd /workspace
CASE=cvdp_copilot_gaussian_rounding_div_0022
```

初始化提交文件：

```bash
bash /workspace/p1_init_case.sh $CASE
```

生成 OpenCode prompt：

```bash
bash /workspace/p1_prompt_for_case.sh $CASE
```

从 `/workspace` 启动 OpenCode：

```bash
opencode -m openrouter/deepseek/deepseek-v4-flash
```

把上面生成的 prompt 粘进去。

人工快速 probe：

```bash
TIMEOUT_SEC=30 bash /workspace/p1_probe_case.sh $CASE
echo "PROBE_EXIT=$?"
```

人工全量 smoke test：

```bash
TIMEOUT_SEC=240 bash /workspace/p1_full_case.sh $CASE
echo "FULL_EXIT=$?"
```

官方提交结构检查：

```bash
cd /workspace/toolkit
python3 tools/status.py --problem P1
python3 tools/check.py --problem P1
```

## 选题命令

列出所有 P1 case：

```bash
cat /workspace/problems/P1/case_ids.txt
```

按 target LOC 查看最难的 case：

```bash
python3 - <<'PY'
import csv
rows = list(csv.DictReader(open("/workspace/problems/P1/case_table.csv", encoding="utf-8")))
rows.sort(key=lambda r: int(r["target_current_loc"]), reverse=True)
for r in rows[:10]:
    print(r["target_current_loc"], r["id"], r["target_files"])
PY
```

查看 P1 还缺哪些提交：

```bash
cd /workspace/toolkit
python3 tools/status.py --problem P1
```

## 日志命令

查看最近日志：

```bash
ls -lt /workspace/.logs | head
```

读取最新日志：

```bash
tail -n 160 "/workspace/.logs/$(ls -t /workspace/.logs | head -n 1)"
```

查看最近保留的 probe 工作目录：

```bash
ls -lt /workspace/.runs_probe | head
```

## 退出码含义

```text
0   通过
1   编译、仿真或断言失败
2   脚本用法错误，或 case/config 缺失
4   pytest 收集或调用问题
124 超时
137 timeout 后被强杀
127 缺少 pytest、iverilog、vvp 等工具
```

遇到 `124` 或 `137`，把它当作 RTL 失败。比赛迭代时不要用 `gdb` 调 `vvp`，直接简化/修 RTL，然后重新跑 probe。

## 重要边界

不要修改：

```text
/workspace/problems/**
/workspace/p1_*.sh
/workspace/toolkit/tools/**
metadata.json
prompt.md
code/src/**
run_direct.sh
```

只修改复制到这里的 target RTL：

```text
/workspace/submission/P1/<case_id>/
```

本地镜像只是 smoke-test 镜像。最终比赛成绩以官方远程 evaluator 为准。
