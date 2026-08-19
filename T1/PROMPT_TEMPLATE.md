# P1 OpenCode Prompt Template

Inside `/workspace`, generate the exact prompt for one case:

```bash
CASE=cvdp_copilot_barrel_shifter_0058
bash /workspace/p1_prompt_for_case.sh $CASE
```

Paste the generated text into OpenCode.

Core prompt idea:

```text
Use the edathon-p1-fast skill. If it is not auto-loaded, read and follow:
/workspace/toolkit/skills/edathon-p1-fast/SKILL.md

CASE_ID = <case_id>

Work from /workspace. Initialize the case with p1_init_case.sh. Edit only copied target RTL under /workspace/submission/P1/<case_id>/. Iterate with p1_probe_case.sh first. Run p1_full_case.sh only after probe passes. Do not modify /workspace/problems, metadata, prompt, code/src, run_direct.sh, or p1_*.sh. Do not run gdb or unbounded simulations. Stop only when full exits 0.
```
