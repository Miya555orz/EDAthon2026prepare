#!/usr/bin/env bash
set -euo pipefail

CASE_ID="${1:-}"

if [[ -z "$CASE_ID" ]]; then
  echo "Usage: bash /workspace/p2_prompt_for_case.sh <case_id>" >&2
  exit 2
fi

cat <<EOF
你正在做 EDAthon2026 P2 RTL PPA 优化，case_id=$CASE_ID。请使用 edathon-p2-fast skill。

硬性边界：
- 当前 OpenCode 工作目录应为 /workspace/work/opencode_cases/P2/$CASE_ID。
- 不要修改 /workspace/problems/**/data。
- 只编辑当前目录的 candidate.v；不要改 prompt.txt/header.v/unopt.v/testbench.v。
- candidate.v 必须定义 module opt_model，端口与 header.v 完全一致。
- helper module 必须写在 candidate.v 同文件内，且不能与 unopt_model 或 testbench 模块重名。
- correctness 是硬门槛；correctness.ok 不是 true 时，不要讨论 area 优化。

先读：
1. OPENCODE_TASK.md
2. prompt.txt
3. header.v
4. unopt.v
5. testbench.v
6. candidate.v
7. /workspace/problems/P2/README_zh.md
8. /workspace/problems/P2/SCORING_zh.md

固定循环：
1. 每轮只做一个语义保持优化。
2. 运行：
   bash /workspace/p2_eval_case.sh $CASE_ID fast
3. 只有 fast 返回 0 且 correctness.ok=true，才继续优化 area。
4. 确认后：
   bash /workspace/p2_eval_case.sh $CASE_ID status

速度要求：
- 不要 sweep 很多版本。
- 不要重写 evaluator。
- 不要超过 3 分钟无输出；如果卡住，先报告当前命令和日志。

完成时简短报告：
- case_id
- candidate.v 改了什么
- correctness.ok
- public mapped area / baseline area（如果 evaluator 输出）
- fast/status exit code
- 说明 public area 不是官方完整 PPA hidden score
EOF
