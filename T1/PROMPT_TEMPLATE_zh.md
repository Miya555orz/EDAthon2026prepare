# P1 OpenCode Prompt 模板中文说明

在 `/workspace` 中，为单个 case 生成准确 prompt：

```bash
CASE=cvdp_copilot_barrel_shifter_0058
bash /workspace/p1_prompt_for_case.sh $CASE
```

把生成出来的英文 prompt 粘给 OpenCode。建议实际给 OpenCode 使用英文版，因为它更短、更稳定。

核心意思如下：

```text
使用 edathon-p1-fast skill。如果 skill 没有自动加载，就读取并遵循：
/workspace/toolkit/skills/edathon-p1-fast/SKILL.md

CASE_ID = <case_id>

从 /workspace 工作。先用 p1_init_case.sh 初始化该 case 的提交 RTL。只修改 /workspace/submission/P1/<case_id>/ 下复制出来的 target RTL。先用 p1_probe_case.sh 快速迭代，probe 通过后才用 p1_full_case.sh 全量检查。不要修改 /workspace/problems、metadata、prompt、code/src、run_direct.sh 或 p1_*.sh。不要使用 gdb，也不要运行无 timeout 的仿真。只有 full 退出码为 0 才停止。
```
