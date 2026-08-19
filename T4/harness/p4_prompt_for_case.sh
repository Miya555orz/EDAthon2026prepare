#!/usr/bin/env bash
set -euo pipefail

CASE_ID="${1:-}"

if [[ -z "$CASE_ID" ]]; then
  echo "Usage: bash /workspace/p4_prompt_for_case.sh <case_id>" >&2
  exit 2
fi

cat <<EOF
你正在做 EDAthon2026 P4 ASAP7 Polygon DRC 修复，case_id=$CASE_ID。请使用 edathon-p4-fast skill。

硬性边界：
- 当前 OpenCode 工作目录应为 /workspace/work/opencode_cases/P4/$CASE_ID。
- 不要修改 /workspace/problems/**/data。
- 只编辑当前目录的 ${CASE_ID}_repaired.py。
- 只能移动或变形已有 polygon；不要删除 shape，不要新增遮罩 shape。
- 必须保持 top cell 名、layout.dbu=0.00025、cell 结构、原始 layer 集合、每层 shape 数量。
- 脚本必须写出 layout.write("../gds/$CASE_ID.gds")。
- 不要提交 GDS、截图、DRC 报告。

先读：
1. OPENCODE_TASK.md
2. drc_report.json
3. ${CASE_ID}_repaired.py
4. screenshots/ 中相关图片
5. /workspace/problems/P4/README_zh.md
6. /workspace/problems/P4/SCORING_zh.md

快速读题：
  bash /workspace/p4_summary_case.sh $CASE_ID

固定检查循环：
1. 修一个几何簇后就跑：
   bash /workspace/p4_eval_case.sh $CASE_ID quick
2. quick 通过后，必须跑一次完整 ASAP7 DRC deck：
   TIMEOUT_SEC=900 bash /workspace/p4_eval_case.sh $CASE_ID full
3. full DRC 返回 0 后同步并检查提交格式：
   bash /workspace/p4_eval_case.sh $CASE_ID status

策略要求：
- 根据 drc_report.json 的 rule description、bbox、edge_pair/vertices 精确改局部坐标。
- 单位注意：layout.dbu=0.00025，报告坐标通常是 dbu；不要把 nm/um/dbu 混掉。
- 优先选择最小几何改动，避免修一条规则引入新 spacing/enclosure 违例。
- P4 quick/status 不等于 hidden official DRC score；full DRC 是更强的本地 proxy，但仍以官方 hidden evaluator 为准。

完成时简短报告：
- case_id
- 改了哪些 polygon/坐标/bbox
- 保持的不变量
- quick/status 命令与 exit code
- full DRC violation count/exit code
- 仍不确定的 hidden DRC 风险
EOF
