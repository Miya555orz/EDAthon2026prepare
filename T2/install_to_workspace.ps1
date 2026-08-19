param(
    [string]$WorkspacePath = "D:\edathon-problems-toolkit-20260819"
)

$ErrorActionPreference = "Stop"
$PackRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not (Test-Path -LiteralPath (Join-Path $WorkspacePath "problems\P2"))) {
    throw "WorkspacePath does not look like the EDAthon toolkit root: $WorkspacePath"
}

Copy-Item -LiteralPath (Join-Path $PackRoot "harness\p2_cases.sh") -Destination (Join-Path $WorkspacePath "p2_cases.sh") -Force
Copy-Item -LiteralPath (Join-Path $PackRoot "harness\p2_env_check.sh") -Destination (Join-Path $WorkspacePath "p2_env_check.sh") -Force
Copy-Item -LiteralPath (Join-Path $PackRoot "harness\p2_prepare_case.sh") -Destination (Join-Path $WorkspacePath "p2_prepare_case.sh") -Force
Copy-Item -LiteralPath (Join-Path $PackRoot "harness\p2_prompt_for_case.sh") -Destination (Join-Path $WorkspacePath "p2_prompt_for_case.sh") -Force
Copy-Item -LiteralPath (Join-Path $PackRoot "harness\p2_eval_case.sh") -Destination (Join-Path $WorkspacePath "p2_eval_case.sh") -Force

$SkillDir = Join-Path $WorkspacePath "toolkit\skills\edathon-p2-fast"
New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
Copy-Item -LiteralPath (Join-Path $PackRoot "skill\edathon-p2-fast\SKILL.md") -Destination (Join-Path $SkillDir "SKILL.md") -Force

Write-Host "Installed T2 harness into $WorkspacePath"
Write-Host "Next inside container: bash /workspace/p2_env_check.sh"
