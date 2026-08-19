# T2 / P2 command cookbook

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\EDAthon2026\EDAthon2026prepare\T2\install_to_workspace.ps1" -WorkspacePath "D:\edathon-problems-toolkit-20260819"
```

```bash
cd /workspace
bash /workspace/p2_env_check.sh
bash /workspace/p2_cases.sh
bash /workspace/p2_prepare_case.sh Prob021_mux256to1v
cd /workspace/work/opencode_cases/P2/Prob021_mux256to1v
bash /workspace/toolkit/opencode_harness/opencode_once.sh
bash /workspace/p2_prompt_for_case.sh Prob021_mux256to1v
bash /workspace/p2_eval_case.sh Prob021_mux256to1v fast
bash /workspace/p2_eval_case.sh Prob021_mux256to1v status
```
