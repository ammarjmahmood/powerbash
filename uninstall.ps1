# PowerBash Uninstallation Script
# Run with: .\uninstall.ps1

$ErrorActionPreference = "Stop"

$InstallDir = "$env:USERPROFILE\.powerbash"
$BinDir = "$env:USERPROFILE\.local\bin"
$PowerShellProfile = $PROFILE.CurrentUserAllHosts

Write-Host "Uninstalling PowerBash..." -ForegroundColor Yellow

# Remove installation directory
if (Test-Path $InstallDir) {
    Remove-Item -Recurse -Force $InstallDir
    Write-Host "Removed installation directory" -ForegroundColor Green
}

# Remove command script
if (Test-Path "$BinDir\powerbash.bat") {
    Remove-Item -Force "$BinDir\powerbash.bat"
    Write-Host "Removed powerbash command" -ForegroundColor Green
}

# Remove PowerShell module
$ModuleDir = "$env:USERPROFILE\Documents\PowerShell\Modules\PowerBash"
if (Test-Path $ModuleDir) {
    Remove-Item -Recurse -Force $ModuleDir
    Write-Host "Removed PowerBash module" -ForegroundColor Green
}

# Remove from PowerShell profile
if (Test-Path $PowerShellProfile) {
    $ProfileContent = Get-Content $PowerShellProfile -Raw
    if ($ProfileContent -like "*PowerBash*") {
        # Remove PowerBash import and function
        $NewContent = $ProfileContent -replace "(?s)# PowerBash.*?^}", "" -replace "(?s)Import-Module PowerBash.*?`n", ""
        Set-Content -Path $PowerShellProfile -Value $NewContent
        Write-Host "Removed PowerBash from PowerShell profile" -ForegroundColor Green
    }
}

# Remove from PATH (optional - comment out if you want to keep .local/bin in PATH)
# $CurrentPath = [Environment]::GetEnvironmentVariable("Path", "User")
# $NewPath = ($CurrentPath -split ';' | Where-Object { $_ -ne $BinDir }) -join ';'
# [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")

Write-Host ""
Write-Host "PowerBash uninstalled successfully!" -ForegroundColor Green
Write-Host "You may need to restart your PowerShell terminal for changes to take effect." -ForegroundColor Yellow
Write-Host ""
