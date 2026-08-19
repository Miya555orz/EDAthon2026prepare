param(
    [string]$WorkspacePath = "D:\edathon-problems-toolkit-20260819"
)

$ErrorActionPreference = "Stop"
$PrepareRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

foreach ($T in @("T1", "T2", "T3", "T4")) {
    $Installer = Join-Path $PrepareRoot "$T\install_to_workspace.ps1"
    if (Test-Path -LiteralPath $Installer) {
        Write-Host "== Installing $T =="
        & powershell -NoProfile -ExecutionPolicy Bypass -File $Installer -WorkspacePath $WorkspacePath
    } else {
        Write-Warning "Missing installer: $Installer"
    }
}

Write-Host ""
Write-Host "Installed available helpers into $WorkspacePath"
Write-Host "Next inside container:"
Write-Host "  bash /workspace/p2_env_check.sh"
Write-Host "  bash /workspace/p3_env_check.sh"
Write-Host "  bash /workspace/p4_env_check.sh"
