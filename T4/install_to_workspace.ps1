param(
    [string]$WorkspacePath = "D:\edathon-problems-toolkit-20260819"
)

$ErrorActionPreference = "Stop"
$PackRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not (Test-Path -LiteralPath (Join-Path $WorkspacePath "problems\P4"))) {
    throw "WorkspacePath does not look like the EDAthon toolkit root: $WorkspacePath"
}

Copy-Item -LiteralPath (Join-Path $PackRoot "harness\p4_cases.sh") -Destination (Join-Path $WorkspacePath "p4_cases.sh") -Force
Copy-Item -LiteralPath (Join-Path $PackRoot "harness\p4_env_check.sh") -Destination (Join-Path $WorkspacePath "p4_env_check.sh") -Force
Copy-Item -LiteralPath (Join-Path $PackRoot "harness\p4_prepare_case.sh") -Destination (Join-Path $WorkspacePath "p4_prepare_case.sh") -Force
Copy-Item -LiteralPath (Join-Path $PackRoot "harness\p4_summary_case.sh") -Destination (Join-Path $WorkspacePath "p4_summary_case.sh") -Force
Copy-Item -LiteralPath (Join-Path $PackRoot "harness\p4_prompt_for_case.sh") -Destination (Join-Path $WorkspacePath "p4_prompt_for_case.sh") -Force
Copy-Item -LiteralPath (Join-Path $PackRoot "harness\p4_eval_case.sh") -Destination (Join-Path $WorkspacePath "p4_eval_case.sh") -Force
Copy-Item -LiteralPath (Join-Path $PackRoot "harness\p4_full_drc_case.sh") -Destination (Join-Path $WorkspacePath "p4_full_drc_case.sh") -Force

$SkillDir = Join-Path $WorkspacePath "toolkit\skills\edathon-p4-fast"
New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
Copy-Item -LiteralPath (Join-Path $PackRoot "skill\edathon-p4-fast\SKILL.md") -Destination (Join-Path $SkillDir "SKILL.md") -Force

Write-Host "Installed T4 harness into $WorkspacePath"
Write-Host "Next inside container: bash /workspace/p4_env_check.sh"
