不在每个 case 里复制一份 `harness/check.sh`，而是在比赛总目录只放一份通用 `check.sh`。每个 case 只放一个很小的 `.case.env` 配置文件。注释 1

这样容器里只挂一个文件夹：

```
/cases
├─ check.sh                 # 全部 case 共用
├─ case001/
│  ├─ .case.env             # 这一题怎么跑
│  ├─ TASK.txt
│  ├─ rtl/
│  └─ verif/
├─ case002/
│  ├─ .case.env
│  ├─ rtl/
│  └─ verif/
└─ case003/
   └─ ...
```

你做某一题时：

```
cd /cases/case001
bash /cases/check.sh
opencode -m deepseek/deepseek-v4-flash .
```

通用版 `/cases/check.sh` 写成这样：

```
#!/usr/bin/env bash
set -euo pipefail

CASE_DIR="$(pwd -P)"
cd "$CASE_DIR"

if [[ ! -f .case.env ]]; then
  echo "ERROR: .case.env not found in $CASE_DIR"
  exit 2
fi

source ./.case.env

if [[ -f tb.sha256.before ]]; then
  sha256sum -c tb.sha256.before
fi

case "${MODE:?MODE is not set in .case.env}" in
  official)
    if ! declare -p OFFICIAL_CMD >/dev/null 2>&1; then
      echo "ERROR: OFFICIAL_CMD array is not set"
      exit 2
    fi
    "${OFFICIAL_CMD[@]}"
    ;;

  sv)
    : "${TB_TOP:?TB_TOP is not set}"

    if ! declare -p RTL_FILES >/dev/null 2>&1; then
      echo "ERROR: RTL_FILES array is not set"
      exit 2
    fi

    if ! declare -p TB_FILES >/dev/null 2>&1; then
      echo "ERROR: TB_FILES array is not set"
      exit 2
    fi

    verilator --lint-only -Wall "${RTL_FILES[@]}"

    iverilog -g2012 -s "$TB_TOP" -o sim.out \
      "${RTL_FILES[@]}" \
      "${TB_FILES[@]}"

    vvp sim.out | tee sim.log

    if [[ -n "${PASS_PATTERN:-}" ]]; then
      grep -q "$PASS_PATTERN" sim.log
    fi

    ! grep -Ei "${FAIL_PATTERN:-ERROR:|FAILED|FAIL:|FATAL|ASSERT|Assertion|Traceback}" sim.log
    ;;

  pytest)
    if ! declare -p PYTEST_CMD >/dev/null 2>&1; then
      PYTEST_CMD=(pytest -q verif)
    fi

    "${PYTEST_CMD[@]}" | tee sim.log

    if [[ -n "${PASS_PATTERN:-}" ]]; then
      grep -q "$PASS_PATTERN" sim.log
    fi

    ! grep -Ei "${FAIL_PATTERN:-ERROR:|FAILED|FAIL:|FATAL|ASSERT|Assertion|Traceback}" sim.log
    ;;

  *)
    echo "ERROR: Unknown MODE=$MODE"
    exit 2
    ;;
esac
```

然后每个 case 的 `.case.env` 很薄。三种情况分别这样写。

官方已经有命令，比如 `make test`：

```
MODE=official
OFFICIAL_CMD=(make test)
```

官方只给 SV testbench：

```
MODE=sv
TB_TOP=lfsr_8bit_local_tb
RTL_FILES=(rtl/lfsr_8bit.sv)
TB_FILES=(verif/lfsr_8bit_local_tb.sv)
PASS_PATTERN=ALL_TESTS_PASSED
```

官方是 cocotb / pytest：

```
MODE=pytest
PYTEST_CMD=(pytest -q verif)
PASS_PATTERN=
```

比赛时一个 case 的固定操作就是：

```
cd /cases/case001

find verif -type f -print0 | sort -z | xargs -0 sha256sum > tb.sha256.before

bash /cases/check.sh
echo "BASELINE_EXIT=$?"

opencode -m deepseek/deepseek-v4-flash .

bash /cases/check.sh
echo "FINAL_EXIT=$?"
```

给 OpenCode 的 prompt 也固定成：

```
You are solving one EDAthon RTL code completion case in the current directory.

Read the task description and inspect rtl/, verif/, and .case.env.
Modify only files under rtl/.
Do not modify verif/, .case.env, /cases/check.sh, task files, metadata, or scripts.

Your only success criterion is:

bash /cases/check.sh

Iterate by running bash /cases/check.sh, reading compile/simulation/lint errors, and fixing rtl only.
Stop only when bash /cases/check.sh exits with code 0.

Report files changed, implementation approach, command run, final exit code, and ambiguity.
```

重点：容器只挂一个大文件夹 `/cases`，但 OpenCode 还是在 `case001`、`case002` 里面分别启动。不要在 `/cases` 根目录启动 OpenCode，否则它会看到太多 case，既浪费 token，也容易误改别的题。