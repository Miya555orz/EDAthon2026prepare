# EDAthon2026 小白命令大全

这份只讲“怎么打开、怎么跑、怎么检查”，不讲算法。

## 0. OpenRouter API 是干啥的

OpenRouter API key 是给 OpenCode 调用大模型用的。

```text
OpenCode -> OpenRouter API -> DeepSeek V4 Flash -> 帮你读文件/改代码/跑命令
```

它不是：

- 不是 Docker 密码；
- 不是 SSH 密码；
- 不是提交入口；
- 不是评分器；
- 不是 GitHub 登录。

比赛环境已经配置好 OpenRouter API key。你不要运行 `/connect`，不要自己粘 key，不要改模型配置。

你只需要检查它通不通：

```bash
cd /workspace
python3 /workspace/toolkit/tools/check_api_key.py
```

OpenCode 界面应显示 OpenRouter / DeepSeek V4 Flash。

## 1. 明天正式环境：打开远程 workspace

正式比赛评分只看远程 Docker 容器：

```text
/workspace/submission/
```

在 VS Code Remote SSH 里打开的 `/workspace`，就是远程 Docker 容器里的 workspace。

SSH 信息：

```text
HostName edathon.cs.cityu.edu.hk
User root
Port 2200 + 队伍编号
Password: 桌面 EDAthon/ssh_password.txt
```

PowerShell 可以直接 SSH：

```powershell
ssh -p 22XX root@edathon.cs.cityu.edu.hk
```

VS Code 方式：

```powershell
code --install-extension ms-vscode-remote.remote-ssh
notepad $env:USERPROFILE\.ssh\config
```

在 config 里填：

```text
Host edathon-remote
    HostName edathon.cs.cityu.edu.hk
    User root
    Port 22XX
```

然后 VS Code：`F1` -> `Remote-SSH: Connect to Host...` -> `edathon-remote` -> 打开文件夹 `/workspace`。

## 2. 本地练习环境：PowerShell 打开 Docker workspace

你本地 Windows 题目包：

```text
D:\edathon-problems-toolkit-20260819
```

映射到容器里就是：

```text
/workspace
```

启动 Docker Desktop：

```powershell
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
```

检查 Docker 是否好了：

```powershell
docker version
docker images
```

启动本地容器：

```powershell
$Ws = "D:\edathon-problems-toolkit-20260819"
$Img = "edathon-openroad-tools:local"

docker run --rm -it `
  --name edathon-work `
  --mount "type=bind,source=$Ws,target=/workspace" `
  --workdir /workspace `
  $Img `
  bash
```

如果容器已经开着，新开一个 PowerShell 进入它：

```powershell
docker ps
docker exec -it edathon-work bash
```

退出容器：

```bash
exit
```

如果容器名冲突：

```powershell
docker ps -a
docker stop edathon-work
```

## 3. 安装我们的 T1-T4 辅助脚本

PowerShell：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\EDAthon2026\EDAthon2026prepare\install_all_to_workspace.ps1" -WorkspacePath "D:\edathon-problems-toolkit-20260819"
```

容器内检查：

```bash
cd /workspace
bash /workspace/p1_env_check.sh
bash /workspace/p2_env_check.sh
bash /workspace/p3_env_check.sh
bash /workspace/p4_env_check.sh
```

## 4. 打开 OpenCode

容器内：

```bash
cd /workspace
python3 /workspace/toolkit/tools/check_api_key.py
opencode
```

OpenCode 常用：

```text
/new       新会话
/models    换模型
/sessions  看旧会话
/help      帮助
/exit      退出
@路径       引用文件
!命令       自己跑一条命令
```

不要运行：

```text
/connect
```

## 5. P1 操作流程

容器内：

```bash
cd /workspace
bash /workspace/p1_env_check.sh
bash /workspace/p1_init_case.sh <case_id>
cd /workspace/.runs/<run_dir>/case/code
bash /workspace/p1_prompt_for_case.sh <case_id>
```

把 prompt 粘给 OpenCode。

检查：

```bash
TIMEOUT_SEC=30 bash /workspace/p1_probe_case.sh <case_id>
TIMEOUT_SEC=240 bash /workspace/p1_full_case.sh <case_id>
python3 /workspace/toolkit/tools/check.py --problem P1
python3 /workspace/toolkit/tools/status.py --problem P1
```

## 6. P2 操作流程

```bash
cd /workspace
bash /workspace/p2_env_check.sh
bash /workspace/p2_cases.sh
bash /workspace/p2_prepare_case.sh int_sqrt2
cd /workspace/work/opencode_cases/P2/int_sqrt2
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p2_prompt_for_case.sh int_sqrt2
```

OpenCode 改完：

```bash
bash /workspace/p2_eval_case.sh int_sqrt2 fast
bash /workspace/p2_eval_case.sh int_sqrt2 json
bash /workspace/p2_eval_case.sh int_sqrt2 status
```

## 7. P3 操作流程

```bash
cd /workspace
bash /workspace/p3_env_check.sh
bash /workspace/p3_cases.sh
bash /workspace/p3_prepare_case.sh CAN-Bus
cd /workspace/work/opencode_cases/P3/CAN-Bus
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p3_prompt_for_case.sh CAN-Bus
```

OpenCode 改完，先只跑快速结构：

```bash
bash /workspace/p3_eval_case.sh CAN-Bus struct
bash /workspace/p3_eval_case.sh CAN-Bus status
```

如果官方 ORFS bundle 可用，再跑：

```bash
export CHIPBENCH_ORFS_FLOW_DIR=/official-bundle/flow
export CHIPBENCH_DESIGN_HOME=/official-bundle/designs
TIMEOUT_SEC=1800 bash /workspace/p3_eval_case.sh CAN-Bus place
```

## 8. P4 操作流程

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

OpenCode 改完：

```bash
bash /workspace/p4_eval_case.sh Polygon117 quick
TIMEOUT_SEC=900 bash /workspace/p4_eval_case.sh Polygon117 full
bash /workspace/p4_eval_case.sh Polygon117 status
```

## 9. 最后交卷前检查

```bash
cd /workspace

python3 /workspace/toolkit/tools/check.py --problem P1
python3 /workspace/toolkit/tools/check.py --problem P2
python3 /workspace/toolkit/tools/check.py --problem P3
python3 /workspace/toolkit/tools/check.py --problem P4

python3 /workspace/toolkit/tools/status.py --problem P1
python3 /workspace/toolkit/tools/status.py --problem P2
python3 /workspace/toolkit/tools/status.py --problem P3
python3 /workspace/toolkit/tools/status.py --problem P4

find /workspace/submission -maxdepth 4 -type f | sort
```

## 10. 如果在机房电脑本地做了，上传远程

每台电脑先保存连接信息：

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

先 dry-run：

```bash
python3 tools/upload.py /path/to/submission --dry-run
```

## 11. 最常见错误

- 忘了上传到远程容器：正式 0。
- OpenCode 只报告“成功”，但你没跑 check/status：不放心。
- P2 没有 `module opt_model`：该 case 0。
- P4 没写 `layout.write("../gds/<case>.gds")`：该 case 0。
- P3 只写 Tcl 片段，不是完整 global_place stage：高风险。
- 改了 `/workspace/problems/**/data`：不要。
- 运行 `/connect` 或乱改 API key：不要。

