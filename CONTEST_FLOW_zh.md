# EDAthon2026 明日比赛流程速查

本文是 `/workspace/toolkit/tutorials` 官方教程的压缩版。最终以比赛现场 `/workspace/problems/P?/README_zh.md`、`SCORING_zh.md` 和主办方说明为准。

## 0. 你会拿到什么环境

每队通常有三套环境：

```text
机房电脑 A     可读题、改文件、跑公开自测；本地文件不自动计分
机房电脑 B     同上
远程容器       正式评分只收集这里的 /workspace/submission/
```

最重要的一句：

```text
最终评分只看远程容器 /workspace/submission/
```

机房电脑和远程容器磁盘互不相通。本机做完必须上传到远程容器，或者直接在远程容器里做。

## 1. 连接远程容器

SSH 端口：

```text
2200 + 队伍编号
```

例如 team07：

```text
2207
```

主机、用户：

```text
HostName edathon.cs.cityu.edu.hk
User root
Port 22XX
```

密码在桌面：

```text
EDAthon/ssh_password.txt
```

OpenRouter key 在桌面：

```text
EDAthon/openrouter_api_key.txt
```

不要泄露给其他队伍。

### VS Code Remote SSH

1. 安装 VS Code。
2. 安装扩展 `Remote - SSH`。
3. 打开 SSH config，一般是：

```text
C:\Users\<用户名>\.ssh\config
```

写入：

```text
Host edathon-remote
    HostName edathon.cs.cityu.edu.hk
    User root
    Port 22XX
```

4. `F1` → `Remote-SSH: Connect to Host...` → `edathon-remote`。
5. 打开远程文件夹：

```text
/workspace
```

### 终端 SSH

```bash
ssh -p 22XX root@edathon.cs.cityu.edu.hk
```

不要扫描其他端口，不要尝试登录其他队伍。

## 2. 登录后第一轮检查

进入远程容器：

```bash
cd /workspace
ls problems submission toolkit
```

检查队伍信息和 API：

```bash
cd /workspace/toolkit
python3 tools/info.py
python3 tools/check_api_key.py
opencode --version
```

OpenCode 应显示 OpenRouter / DeepSeek V4 Flash。不要运行 `/connect`，不要自己粘 API key。

阅读四题：

```bash
less /workspace/problems/P1/README_zh.md
less /workspace/problems/P1/SCORING_zh.md
cat  /workspace/problems/P1/case_ids.txt

less /workspace/problems/P2/README_zh.md
less /workspace/problems/P2/SCORING_zh.md
cat  /workspace/problems/P2/case_ids.txt

less /workspace/problems/P3/README_zh.md
less /workspace/problems/P3/SCORING_zh.md
cat  /workspace/problems/P3/case_ids.txt

less /workspace/problems/P4/README_zh.md
less /workspace/problems/P4/SCORING_zh.md
cat  /workspace/problems/P4/case_ids.txt
```

如果 `/workspace` 不可写、题目缺失、API 检查失败、OpenCode 不对，立即找主办方。

## 3. OpenCode 怎么开

OpenRouter API key 是 OpenCode 调用 DeepSeek V4 Flash 的模型钥匙。它不是 SSH 密码、不是 Docker 密码、不是提交系统、也不是评分器。比赛环境已配置好，不要运行 `/connect`，不要自己粘 key。

推荐从 `/workspace` 启动：

```bash
cd /workspace
python3 /workspace/toolkit/tools/check_api_key.py
opencode
```

常用操作：

```text
/new       新会话
/models    换模型
/sessions  看旧会话
/help      帮助
/exit      退出
@path      引用文件
!command   自己跑命令
```

不要运行：

```text
/connect
```

环境已经配置好 key 和模型。

给 Agent 任务时，必须写清：

1. 当前题目和 case；
2. 允许修改哪个文件；
3. 最终提交路径；
4. 完成后跑什么检查命令。

## 4. 正式提交路径

只交这些路径。`submission/` 初始为空。

```text
P1:
/workspace/submission/P1/<case_id>/<target_path>

P2:
/workspace/submission/P2/<case_id>/candidate.v

P3:
/workspace/submission/P3/global_place.tcl
/workspace/submission/P3/cases/<case_id>.tcl

P4:
/workspace/submission/P4/cases/<case_id>_repaired.py
```

多余 README、log、GDS、截图、压缩包不会加分；不要把整个 task 目录拷进 submission。

## 5. 四题一句话策略

### P1 RTL 补全

目标：35 个 medium case，官方 testbench 仿真通过一个算一个。

提交：

```text
/workspace/submission/P1/<case_id>/<target_path>
```

检查：

```bash
python3 /workspace/toolkit/tools/check.py --problem P1
python3 /workspace/toolkit/tools/status.py --problem P1
```

用我们 T1 harness 时：

```bash
bash /workspace/p1_env_check.sh
```

### P2 RTL PPA 优化

目标：功能正确前提下降 area/delay/power。公开工具能查 correctness 和 mapped area，但不是官方完整分。

提交：

```text
/workspace/submission/P2/<case_id>/candidate.v
```

`candidate.v` 必须有：

```verilog
module opt_model(...)
```

用我们 T2 harness：

```bash
bash /workspace/p2_env_check.sh
bash /workspace/p2_prepare_case.sh int_sqrt2
cd /workspace/work/opencode_cases/P2/int_sqrt2
bash /workspace/p2_prompt_for_case.sh int_sqrt2
bash /workspace/p2_eval_case.sh int_sqrt2 fast
bash /workspace/p2_eval_case.sh int_sqrt2 status
```

### P3 global placement Tcl

目标：写完整 ORFS `global_place` 阶段脚本。公开 `struct/status` 只保证格式，不等于性能分。

提交：

```text
/workspace/submission/P3/global_place.tcl
/workspace/submission/P3/cases/<case_id>.tcl
```

per-case 脚本优先于全局脚本。

用我们 T3 harness：

```bash
bash /workspace/p3_env_check.sh
bash /workspace/p3_prepare_case.sh CAN-Bus
cd /workspace/work/opencode_cases/P3/CAN-Bus
bash /workspace/p3_prompt_for_case.sh CAN-Bus
bash /workspace/p3_eval_case.sh CAN-Bus struct
bash /workspace/p3_eval_case.sh CAN-Bus status
```

如果官方 ORFS bundle 可用：

```bash
export CHIPBENCH_ORFS_FLOW_DIR=/official-bundle/flow
export CHIPBENCH_DESIGN_HOME=/official-bundle/designs
TIMEOUT_SEC=1800 bash /workspace/p3_eval_case.sh CAN-Bus place
```

### P4 ASAP7 Polygon DRC 修复

目标：35 个 case，clean pass 才得分。要 final violations=0 且 new violations=0。

提交：

```text
/workspace/submission/P4/cases/<case_id>_repaired.py
```

脚本必须写：

```python
layout.write("../gds/<case_id>.gds")
```

用我们 T4 harness：

```bash
bash /workspace/p4_env_check.sh
bash /workspace/p4_prepare_case.sh Polygon117
cd /workspace/work/opencode_cases/P4/Polygon117
bash /workspace/p4_summary_case.sh Polygon117
bash /workspace/p4_prompt_for_case.sh Polygon117
bash /workspace/p4_eval_case.sh Polygon117 quick
TIMEOUT_SEC=900 bash /workspace/p4_eval_case.sh Polygon117 full
bash /workspace/p4_eval_case.sh Polygon117 status
```

## 6. 如果在机房电脑本地做了答案，怎么上传到远程容器

每台电脑先保存远程连接信息：

```bash
cd /workspace/toolkit
python3 tools/upload.py --port 22XX --password '<PASSWORD>' --save
```

上传某题：

```bash
python3 tools/upload.py /path/to/submission --problem P1
python3 tools/upload.py /path/to/submission --problem P2
python3 tools/upload.py /path/to/submission --problem P3
python3 tools/upload.py /path/to/submission --problem P4
```

先演练不真正上传：

```bash
python3 tools/upload.py /path/to/submission --dry-run
```

下载远程当前提交：

```bash
python3 tools/download.py
```

检查上传配置：

```bash
python3 tools/upload.py --check
```

默认上传会覆盖同名文件，但不会删除队友在远程已有、而你本次没上传的文件。只有确认要让远程目录和本地完全一致时才用：

```bash
python3 tools/upload.py /path/to/submission --replace --yes
```

## 7. 最后 30 分钟收尾

逐题跑：

```bash
python3 /workspace/toolkit/tools/check.py --problem P1
python3 /workspace/toolkit/tools/check.py --problem P2
python3 /workspace/toolkit/tools/check.py --problem P3
python3 /workspace/toolkit/tools/check.py --problem P4

python3 /workspace/toolkit/tools/status.py --problem P1
python3 /workspace/toolkit/tools/status.py --problem P2
python3 /workspace/toolkit/tools/status.py --problem P3
python3 /workspace/toolkit/tools/status.py --problem P4
```

看最终提交树：

```bash
find /workspace/submission -maxdepth 4 -type f | sort
```

确认答案真的在远程容器，不是在机房电脑本地。

## 8. 常见坑

- 只在机房电脑改了，没上传远程容器：不计分。
- P2 没有 `module opt_model`：该 case 0 分。
- P4 没写 `../gds/<case>.gds`：该 case 0 分。
- P3 只有片段，不是完整 `global_place.tcl` stage：高风险。
- 把整个 task/log/GDS/截图拷进 submission：不会加分，还容易混乱。
- 只相信 Agent 的文字结论，不跑 `check.py/status.py`：危险。
- 自己运行 `/connect` 或改模型/key：不要。

## 9. 明天最短工作节奏

```text
开赛 0-15 分钟：
  登录远程容器，检查 /workspace、API、OpenCode、四题 case_ids。

中段：
  P1/P2/P4 先拿容易 case；P3 先保证 struct/status 可评分。

每完成一个 case：
  sync 到 /workspace/submission
  跑对应 check/status

最后 30 分钟：
  全题 check.py + status.py
  确认远程 /workspace/submission 里有答案
```
