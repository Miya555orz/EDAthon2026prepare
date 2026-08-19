---
name: edathon-p3-fast
description: EDAthon 2026 P3 global placement Tcl 的快速、安全、固定流程：官方 toolkit harness + 可选 ORFS placement/full 检查。
---

# EDAthon P3 快速布局流程

只在 `/workspace/work/opencode_cases/P3/<case_id>` 里使用。

按顺序阅读：

1. `OPENCODE_TASK.md`
2. `README_INPUTS.md`
3. `RUN_P3.md`
4. `/workspace/problems/P3/README_zh.md`
5. `/workspace/problems/P3/SCORING_zh.md`
6. `global_place.tcl`

不要修改 `/workspace/problems/**/data`。通过检查前，只编辑当前工作目录的
`global_place.tcl`。

提交文件必须是完整 ORFS `global_place` 阶段替换脚本：

- 保留/source 正常 ORFS stage 环境；
- `load_design 3_2_place_iop.odb 2_floorplan.sdc`；
- 执行标准单元全局布局；
- 保持顶层设计、die/core、宏位置、IO 位置不变；
- 写出 `$::env(RESULTS_DIR)/3_3_place_gp.odb`。

快速循环：

```bash
bash /workspace/p3_eval_case.sh <case_id> struct
```

如果官方 ORFS bundle 已挂载并设置了环境变量：

```bash
bash /workspace/p3_eval_case.sh <case_id> place
```

如果时间允许，再做下游 smoke：

```bash
TIMEOUT_SEC=3600 bash /workspace/p3_eval_case.sh <case_id> full
```

确认后：

```bash
cd /workspace/work/opencode_cases/P3/<case_id>
python3 /workspace/toolkit/opencode_harness/edathon_harness.py sync
python3 /workspace/toolkit/tools/check.py --problem P3
```

优先保守修改：调 density、padding、timing/routability 开关或
`GLOBAL_PLACEMENT_ARGS`。保留 `fast_route`、metrics report 和最终 `write_db`。
结构检查不是官方分数；HPWL 也不是最终分。最终分取决于下游布线、时序、功耗与合法性。
