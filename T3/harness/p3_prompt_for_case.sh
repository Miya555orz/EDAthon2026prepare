#!/usr/bin/env bash
set -euo pipefail

CASE_ID="${1:-}"
ROOT="${WORKSPACE_ROOT:-/workspace}"

if [[ -z "$CASE_ID" ]]; then
  echo "Usage: bash /workspace/p3_prompt_for_case.sh <case_id>" >&2
  exit 2
fi

cat <<EOF
你正在做 EDAthon2026 P3 global_place.tcl，case_id=$CASE_ID。请使用 edathon-p3-fast skill。

硬性边界：
- 当前 OpenCode 工作目录应为 /workspace/work/opencode_cases/P3/$CASE_ID。
- 不要修改 /workspace/problems/**/data。
- 只编辑当前目录的 global_place.tcl；通过后再 sync 到 submission。
- 提交脚本必须是完整 ORFS global_place stage，不是 Tcl 片段。
- 必须 load_design 3_2_place_iop.odb 2_floorplan.sdc，必须执行标准单元 global_placement，必须 write_db \$::env(RESULTS_DIR)/3_3_place_gp.odb。
- 不要改宏、IO、die/core、顶层设计名；不要提交 ODB/SDC/日志/metrics。

先读：
1. OPENCODE_TASK.md
2. README_INPUTS.md
3. RUN_P3.md
4. /workspace/problems/P3/README_zh.md
5. /workspace/problems/P3/SCORING_zh.md
6. 当前目录 global_place.tcl

固定快速循环：
1. 先跑结构检查：
   bash /workspace/p3_eval_case.sh $CASE_ID struct
2. 如果官方 ORFS bundle 可用，再跑 placement smoke：
   export CHIPBENCH_ORFS_FLOW_DIR=/official-bundle/flow
   export CHIPBENCH_DESIGN_HOME=/official-bundle/designs
   bash /workspace/p3_eval_case.sh $CASE_ID place
3. 通过后同步：
   cd /workspace/work/opencode_cases/P3/$CASE_ID
   python3 /workspace/toolkit/opencode_harness/edathon_harness.py sync
   python3 /workspace/toolkit/tools/check.py --problem P3

策略要求：
- 先从 starter 行为出发，避免删除 load/fast_route/report/write_db 等官方 stage 结构。
- 优先微调 global_placement 参数、density、padding、timing/routability 开关。
- P3 公开包没有最终官方分；不要把 HPWL 或结构检查说成 official score。
- 如果 place/full 挂了，报告第一个失败 stage、日志路径、你改了哪些 Tcl 参数。

完成时简短报告：
- case_id
- 写入文件：global_place.tcl，sync 到 global 还是 per-case
- 策略摘要
- struct/place/status 命令与 exit code
- 仍不确定的官方 bundle/hidden score 风险
EOF
