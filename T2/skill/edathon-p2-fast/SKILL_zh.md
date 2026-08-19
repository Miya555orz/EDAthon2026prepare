---
name: edathon-p2-fast
description: EDAthon 2026 P2 RTL PPA 优化的快速、安全、固定流程：candidate.v、公开 correctness、Yosys mapped-area 检查。
---

# EDAthon P2 快速 PPA 流程

只在 `/workspace/work/opencode_cases/P2/<case_id>` 里使用。

按顺序阅读：

1. `OPENCODE_TASK.md`
2. `prompt.txt`
3. `header.v`
4. `unopt.v`
5. `testbench.v`
6. `candidate.v`
7. `/workspace/problems/P2/README_zh.md`
8. `/workspace/problems/P2/SCORING_zh.md`

不要修改 `/workspace/problems/**/data`。只编辑 `candidate.v`。

硬性要求：

- `candidate.v` 必须定义 `module opt_model`；
- 端口必须与 `header.v` 完全一致；
- helper module 必须写在同一个文件；
- helper 名不能与 `unopt_model` 或 testbench 模块冲突；
- correctness 是硬门槛。

快速循环：

```bash
bash /workspace/p2_eval_case.sh <case_id> fast
```

只有 correctness 通过后才比较 area。需要 JSON 视图时：

```bash
bash /workspace/p2_eval_case.sh <case_id> json
```

确认后：

```bash
bash /workspace/p2_eval_case.sh <case_id> status
```

每轮优先做一个小的语义保持优化：常量传播、mux/decode 简化、布尔因式分解、共享算术、死逻辑删除、寄存器/线网清理、位宽清理。
先保留一个已正确版本，再尝试更激进重写。公开 mapped area 只是 proxy，不是官方 hidden PPA 分。
