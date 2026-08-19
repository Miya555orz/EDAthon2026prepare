# EDAthon2026 T2 prep pack: P2 RTL PPA optimization

This pack makes P2 repeatable: prepare a case, open OpenCode, paste one prompt,
run fast eval, then sync/status.

Installed workspace files:

```text
/workspace/p2_cases.sh
/workspace/p2_env_check.sh
/workspace/p2_prepare_case.sh
/workspace/p2_prompt_for_case.sh
/workspace/p2_eval_case.sh
/workspace/toolkit/skills/edathon-p2-fast/SKILL.md
```

Install:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\EDAthon2026\EDAthon2026prepare\T2\install_to_workspace.ps1" -WorkspacePath "D:\edathon-problems-toolkit-20260819"
```

Run one case:

```bash
cd /workspace
bash /workspace/p2_env_check.sh
bash /workspace/p2_prepare_case.sh Prob021_mux256to1v
cd /workspace/work/opencode_cases/P2/Prob021_mux256to1v
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p2_prompt_for_case.sh Prob021_mux256to1v
```

After OpenCode edits:

```bash
bash /workspace/p2_eval_case.sh Prob021_mux256to1v fast
bash /workspace/p2_eval_case.sh Prob021_mux256to1v status
```
