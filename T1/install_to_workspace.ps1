param(
    [Parameter(Mandatory = $true)]
    [string]$WorkspacePath
)

$ErrorActionPreference = 'Stop'

$PackRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Workspace = Resolve-Path -LiteralPath $WorkspacePath

if (-not (Test-Path -LiteralPath (Join-Path $Workspace 'problems\P1'))) {
    throw "WorkspacePath does not look like an EDAthon workspace: $WorkspacePath"
}

$HarnessFiles = @(
    'p1_env_check.sh',
    'p1_check_case.sh',
    'p1_check_case_fast.sh',
    'p1_init_case.sh',
    'p1_probe_case.sh',
    'p1_full_case.sh',
    'p1_prompt_for_case.sh'
)

foreach ($Name in $HarnessFiles) {
    Copy-Item -LiteralPath (Join-Path $PackRoot "harness\$Name") -Destination (Join-Path $Workspace $Name) -Force
}

$SkillDest = Join-Path $Workspace 'toolkit\skills\edathon-p1-fast'
New-Item -ItemType Directory -Force -Path $SkillDest | Out-Null
Copy-Item -LiteralPath (Join-Path $PackRoot 'skill\edathon-p1-fast\SKILL.md') -Destination (Join-Path $SkillDest 'SKILL.md') -Force

$DockerDest = Join-Path $Workspace 'local-docker'
New-Item -ItemType Directory -Force -Path $DockerDest | Out-Null
Copy-Item -LiteralPath (Join-Path $PackRoot 'local-docker\Dockerfile.p1-cocotb') -Destination (Join-Path $DockerDest 'Dockerfile.p1-cocotb') -Force

Write-Host "Installed T1 harness and skill into:"
Write-Host "  $Workspace"
Write-Host ""
Write-Host "Verify inside the container with:"
Write-Host "  bash -n /workspace/p1_env_check.sh /workspace/p1_init_case.sh /workspace/p1_probe_case.sh /workspace/p1_full_case.sh /workspace/p1_prompt_for_case.sh"
