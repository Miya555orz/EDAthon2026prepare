---
name: edathon-p1-fast
description: 用于 EDAthon P1 RTL 补全 case；通过 init/probe/full harness 快速迭代，只修改官方提交路径下的 target RTL。
---

# EDAthon P1 快速 RTL 补全

从 `/workspace` 工作。官方冻结 P1 case 在 `/workspace/problems/P1/data/cases/`；最终 P1 答案只写到 `/workspace/submission/P1/<case_id>/<target_path>`。

永远不要修改 `/workspace/problems/**`、public testbench、`metadata.json`、`prompt.md`、`run_direct.sh` 或 `/workspace` 下的 P1 harness 脚本。只编辑 case 的 `metadata.json:target_files` 中列出的 RTL 文件，并且这些文件必须先复制到 `/workspace/submission/P1/<case_id>/` 的对应路径。

## 快速单题循环

处理某个 case 时：

1. 初始化 submission target：

   ```bash
   bash /workspace/p1_init_case.sh <case_id>
   ```

2. 阅读该 case 的 `prompt.md`、`metadata.json`、starter target RTL、`code/src/.env`、`code/src/test_runner.py` 和相关 public cocotb 测试。

3. 先用 probe harness 快速迭代：

   ```bash
   TIMEOUT_SEC=30 bash /workspace/p1_probe_case.sh <case_id>
   ```

   退出码 `0` 表示第一个收集到的 public pytest node 通过。退出码 `1` 表示编译/仿真/断言失败。退出码 `124` 或 `137` 表示超时/挂住；把它当作 RTL 失败。

4. 只有 probe 通过后，才跑完整 public smoke test：

   ```bash
   TIMEOUT_SEC=240 bash /workspace/p1_full_case.sh <case_id>
   ```

5. full 通过后，检查官方提交结构：

   ```bash
   cd /workspace/toolkit && python3 tools/status.py --problem P1 && python3 tools/check.py --problem P1
   ```

## 速度规则

普通迭代时，不要运行 `gdb`，不要调试 `vvp` 内部，不要生成波形，不要运行没有 timeout 的 pytest/vvp 命令。所有仿真命令都必须带 `timeout`。

如果运行卡在 `0.00ns`，优先怀疑 0 时间组合循环或 `always @*` 自触发。简化 RTL，并初始化所有组合临时变量，不要去调仿真器。

probe 没过之前，不要反复跑完整 10-test suite。时间紧时，如果同一个假设多次失败，就先切换到下一个 case。

## 报告

报告 case id、修改的 submission RTL 文件、实现思路、最终 probe/full 命令、退出码和剩余歧义。不要把 agent 的文字当作证明；harness 退出码才是证据。
