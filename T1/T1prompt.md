You are solving one EDAthon RTL code completion case in the current directory.

Read the task description and inspect rtl/, verif/, and harness/.
Modify only files under rtl/. Do not modify verif/, harness/, task files, metadata, or scripts.

Your only success criterion is:

bash harness/check.sh

Iterate by running bash harness/check.sh, reading the compile/simulation/lint errors, and fixing rtl only.
Preserve the module interface expected by the testbench.
Do not hardcode visible test cases.
Stop only when bash harness/check.sh exits with code 0.

At the end, report files changed, implementation approach, command run, final exit code, and remaining ambiguity.