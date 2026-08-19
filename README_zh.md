# EDAthon2026 prepare 总包

这里是 T1/T2/T3/T4 的赛前资料包。建议上传整个目录，或者上传同目录下生成的 zip。

## 目录

```text
D:\EDAthon2026\EDAthon2026prepare
├─ T1  # P1 RTL code completion，已验证多题
├─ T2  # P2 RTL PPA optimization
├─ T3  # P3 global placement Tcl
└─ T4  # P4 ASAP7 Polygon DRC repair，默认 quick + full DRC + status
```

## 一键安装到本地 workspace

PowerShell：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\EDAthon2026\EDAthon2026prepare\install_all_to_workspace.ps1" -WorkspacePath "D:\edathon-problems-toolkit-20260819"
```

## 容器内最常用命令

P1：

```bash
bash /workspace/p1_env_check.sh
```

P2：

```bash
bash /workspace/p2_env_check.sh
bash /workspace/p2_prepare_case.sh int_sqrt2
cd /workspace/work/opencode_cases/P2/int_sqrt2
bash /workspace/p2_prompt_for_case.sh int_sqrt2
bash /workspace/p2_eval_case.sh int_sqrt2 fast
bash /workspace/p2_eval_case.sh int_sqrt2 status
```

P3：

```bash
bash /workspace/p3_env_check.sh
bash /workspace/p3_prepare_case.sh CAN-Bus
cd /workspace/work/opencode_cases/P3/CAN-Bus
bash /workspace/p3_prompt_for_case.sh CAN-Bus
bash /workspace/p3_eval_case.sh CAN-Bus struct
bash /workspace/p3_eval_case.sh CAN-Bus status
```

P4：

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

## 明天原则

- P1：能跑官方 testbench 就跑官方 testbench。
- P2：correctness 是硬门槛，area 只是公开 proxy。
- P3：`struct/status` 不是性能分；有官方 ORFS bundle 才跑 `place/full`。
- P4：默认 `quick -> full DRC -> status`，full DRC 过了才把该 case 当“高概率 clean”。
