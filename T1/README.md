# EDAthon 2026 P1 Fast Harness Pack

This folder contains only the P1 workflow helpers, not solved RTL answers. Use it only when contest rules allow bringing your own helper scripts/materials. Official scoring still reads `/workspace/submission/P1/` in the official container.

## What To Copy Where

Copy these files into the EDAthon workspace root:

```text
T1/harness/p1_check_case.sh       -> /workspace/p1_check_case.sh
T1/harness/p1_check_case_fast.sh  -> /workspace/p1_check_case_fast.sh
T1/harness/p1_env_check.sh        -> /workspace/p1_env_check.sh
T1/harness/p1_init_case.sh        -> /workspace/p1_init_case.sh
T1/harness/p1_probe_case.sh       -> /workspace/p1_probe_case.sh
T1/harness/p1_full_case.sh        -> /workspace/p1_full_case.sh
T1/harness/p1_prompt_for_case.sh  -> /workspace/p1_prompt_for_case.sh
```

Copy the skill here:

```text
T1/skill/edathon-p1-fast/SKILL.md -> /workspace/toolkit/skills/edathon-p1-fast/SKILL.md
```

Optional local mirror Dockerfile:

```text
T1/local-docker/Dockerfile.p1-cocotb -> /workspace/local-docker/Dockerfile.p1-cocotb
```

The scripts assume the official problem tree exists at:

```text
/workspace/problems/P1/data/cases/<case_id>/
```

Answers are written only to:

```text
/workspace/submission/P1/<case_id>/<target_path>
```

## Install On Lab PC

If your official/unpacked workspace is on Windows, run PowerShell:

```powershell
$Pack = 'D:\EDAthon2026\EDAthon2026prepare\T1'
$Workspace = 'D:\edathon-problems-toolkit-20260819'

powershell -ExecutionPolicy Bypass -File "$Pack\install_to_workspace.ps1" -WorkspacePath $Workspace
```

If you are already inside a Linux container and this pack is mounted somewhere:

```bash
bash /path/to/T1/install_to_workspace.sh /workspace
```

## Local Docker Commands

Build the local P1 image only if your current image lacks `pytest` or `cocotb`:

```powershell
$Workspace = 'D:\edathon-problems-toolkit-20260819'

docker build `
  -f "$Workspace\local-docker\Dockerfile.p1-cocotb" `
  -t edathon-p1-cocotb:local `
  "$Workspace\local-docker"
```

Start a fresh local container:

```powershell
$Workspace = 'D:\edathon-problems-toolkit-20260819'

docker run -it `
  --name edathon-p1-local `
  --mount "type=bind,source=$Workspace,target=/workspace" `
  --workdir /workspace `
  edathon-p1-cocotb:local `
  bash
```

If the container already exists:

```powershell
docker start -ai edathon-p1-local
```

Open a second shell into the running container:

```powershell
docker exec -it edathon-p1-local bash
```

Stop stuck OpenCode simulations from another PowerShell:

```powershell
docker exec edathon-p1-local bash -lc "pkill -TERM -f 'pytest|vvp|/tmp/opencode/run_one.sh' || true"
```

Check tools inside the container:

```bash
bash /workspace/p1_env_check.sh /workspace
```

Manual equivalent:

```bash
python3 - <<'PY'
import importlib.util
for m in ["pytest", "cocotb", "cocotb_tools.runner"]:
    print(m, "OK" if importlib.util.find_spec(m) else "MISSING")
PY
command -v iverilog
command -v vvp
```

If `p1_env_check.sh` prints `ENV_CHECK_FAIL`, do not switch to an external Docker image during the contest. Save the output and ask the organizer, because P1 `run_direct.sh` requires these benchmark dependencies. If the rules explicitly allow package installation inside the official container, use only the organizer-approved command; otherwise continue with compile-only RTL checks as a temporary diagnostic, not as proof of scoring pass.

Check script syntax:

```bash
bash -n /workspace/p1_init_case.sh \
  /workspace/p1_probe_case.sh \
  /workspace/p1_full_case.sh \
  /workspace/p1_prompt_for_case.sh
```

## One Case Workflow

Pick a case:

```bash
cd /workspace
CASE=cvdp_copilot_gaussian_rounding_div_0022
```

Initialize copied target RTL:

```bash
bash /workspace/p1_init_case.sh $CASE
```

Generate the OpenCode prompt:

```bash
bash /workspace/p1_prompt_for_case.sh $CASE
```

Start OpenCode from `/workspace`:

```bash
opencode -m openrouter/deepseek/deepseek-v4-flash
```

Paste the generated prompt.

Manual probe check:

```bash
TIMEOUT_SEC=30 bash /workspace/p1_probe_case.sh $CASE
echo "PROBE_EXIT=$?"
```

Manual full check:

```bash
TIMEOUT_SEC=240 bash /workspace/p1_full_case.sh $CASE
echo "FULL_EXIT=$?"
```

Official submission shape check:

```bash
cd /workspace/toolkit
python3 tools/status.py --problem P1
python3 tools/check.py --problem P1
```

## Case Selection Commands

List all P1 cases:

```bash
cat /workspace/problems/P1/case_ids.txt
```

Show the hardest cases by current target LOC:

```bash
python3 - <<'PY'
import csv
rows = list(csv.DictReader(open("/workspace/problems/P1/case_table.csv", encoding="utf-8")))
rows.sort(key=lambda r: int(r["target_current_loc"]), reverse=True)
for r in rows[:10]:
    print(r["target_current_loc"], r["id"], r["target_files"])
PY
```

Show missing submitted P1 targets:

```bash
cd /workspace/toolkit
python3 tools/status.py --problem P1
```

## Log Commands

Recent logs:

```bash
ls -lt /workspace/.logs | head
```

Read the newest log:

```bash
tail -n 160 "/workspace/.logs/$(ls -t /workspace/.logs | head -n 1)"
```

Recent kept probe workdirs:

```bash
ls -lt /workspace/.runs_probe | head
```

## Exit Code Meaning

```text
0   pass
1   compile, simulation, or assertion failure
2   wrong script usage or missing case/config
4   pytest collection or invocation problem
124 timeout
137 killed after timeout
127 missing tool such as pytest, iverilog, or vvp
```

Treat `124` and `137` as failing RTL attempts. Do not debug `vvp` with `gdb` during contest iteration; simplify/fix RTL and rerun the probe.

## Important Boundaries

Do not modify:

```text
/workspace/problems/**
/workspace/p1_*.sh
/workspace/toolkit/tools/**
metadata.json
prompt.md
code/src/**
run_direct.sh
```

Only edit copied target RTL files under:

```text
/workspace/submission/P1/<case_id>/
```

The local image is a smoke-test mirror. Final contest scoring is whatever the official remote evaluator reports.
