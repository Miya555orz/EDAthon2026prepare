---
name: edathon-p4-fast
description: EDAthon 2026 P4 ASAP7 Polygon DRC 修复的快速、安全、固定流程：鲁棒结构/GDS 检查 + 官方 submission sync。
---

# EDAthon P4 快速 DRC 修复流程

只在 `/workspace/work/opencode_cases/P4/<case_id>` 里使用。

按顺序阅读：

1. `OPENCODE_TASK.md`
2. `drc_report.json`
3. `<case_id>_repaired.py`
4. 相关 `screenshots/*`
5. `/workspace/problems/P4/README_zh.md`
6. `/workspace/problems/P4/SCORING_zh.md`

不要修改 `/workspace/problems/**/data`。只编辑当前工作目录的
`<case_id>_repaired.py`。

硬性不变量：

- 保持 top cell 名；
- 保持 `layout.dbu = 0.00025`；
- 保持原始 cell 结构；
- 保持原始 layer 集合；
- 保持每层 shape 数量；
- 只能移动或变形已有 polygon；
- 不要删除 shape；
- 不要新增遮罩/dummy shape 来掩盖违例；
- 必须写出 `../gds/<case_id>.gds`。

快速循环：

```bash
bash /workspace/p4_summary_case.sh <case_id>
bash /workspace/p4_eval_case.sh <case_id> quick
```

最终同步前，如果 KLayout 可用，必须跑一次完整本地 ASAP7 DRC deck：

```bash
TIMEOUT_SEC=900 bash /workspace/p4_eval_case.sh <case_id> full
```

确认后：

```bash
bash /workspace/p4_eval_case.sh <case_id> status
```

以 DRC report 的 bbox/edge/vertices 为准。优先做最小局部坐标修改，满足规则描述即可。
不要乱动无关 polygon，因为隐藏评分要求 final violations=0 且 new violations=0。
quick/status 只是弱 proxy；完整本地 ASAP7 DRC 是更强 proxy，判定某题“可能 clean”前应跑一次。
最终仍以 hidden 官方 evaluator 为准。
