# PowerBash Installation Script for PowerShell
# Run with: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser (if needed)
# Then: .\install.ps1
# Or: irm https://raw.githubusercontent.com/ammarjmahmood/powerbash/main/install.ps1 | iex
# Note: This script uses 'py' (Python launcher) instead of 'python' for PowerShell compatibility

$ErrorActionPreference = "Stop"

$InstallDir = "$env:USERPROFILE\.powerbash"
$RepoBase = "https://raw.githubusercontent.com/ammarjmahmood/powerbash/main"

Write-Host "Installing PowerBash..." -ForegroundColor Cyan
Write-Host "This will download files from GitHub if needed..." -ForegroundColor Gray

# Check for Python (use 'py' launcher for PowerShell compatibility)
try {
    $pythonVersion = py --version 2>&1
    Write-Host "Found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "Python is required. Please install Python 3.8+ from https://www.python.org/" -ForegroundColor Red
    Write-Host "Note: On Windows, Python is typically accessed via 'py' command in PowerShell" -ForegroundColor Yellow
    exit 1
}

# Function to download file from GitHub
function Download-File {
    param(
        [string]$Url,
        [string]$Destination
    )
    try {
        Write-Host "Downloading $(Split-Path -Leaf $Destination)..." -ForegroundColor Gray
        Invoke-WebRequest -Uri $Url -OutFile $Destination -UseBasicParsing -ErrorAction Stop
        return $true
    } catch {
        Write-Host "Failed to download $Url" -ForegroundColor Red
        return $false
    }
}

# Get script directory (where install.ps1 is located, if running from local file)
$scriptPath = $null
if ($MyInvocation.MyCommand.Path) {
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
}

# Create installation directory
if (Test-Path $InstallDir) {
    Write-Host "Updating existing installation..." -ForegroundColor Yellow
} else {
    Write-Host "Creating installation directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

Set-Location $InstallDir

# Download required files from GitHub if not found locally
$filesToDownload = @(
    @{Name="powerbash.py"; Url="$RepoBase/powerbash.py"},
    @{Name="nl_to_cmd.py"; Url="$RepoBase/nl_to_cmd.py"},
    @{Name="requirements.txt"; Url="$RepoBase/requirements.txt"},
    @{Name="PowerBash.psm1"; Url="$RepoBase/PowerBash.psm1"}
)

foreach ($file in $filesToDownload) {
    $localPath = Join-Path $InstallDir $file.Name
    $localScriptPath = Join-Path $scriptPath $file.Name
    
    # First try to copy from local script directory (if running from cloned repo)
    if ($scriptPath -and (Test-Path $localScriptPath)) {
        Copy-Item $localScriptPath -Destination $localPath -Force
        Write-Host "Copied $($file.Name) from local directory" -ForegroundColor Gray
    }
    # If not found locally, download from GitHub
    elseif (-not (Test-Path $localPath)) {
        if (-not (Download-File -Url $file.Url -Destination $localPath)) {
            Write-Host "Error: Failed to download $($file.Name)" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Found existing $($file.Name)" -ForegroundColor Gray
    }
}

Set-Location $InstallDir

# Create virtual environment
Write-Host "Setting up Python environment..." -ForegroundColor Yellow
if (Test-Path "venv") {
    Remove-Item -Recurse -Force "venv"
}
py -m venv venv

# Activate and install dependencies
& "$InstallDir\venv\Scripts\Activate.ps1"
py -m pip install --quiet --upgrade pip
py -m pip install --quiet -r requirements.txt

# Create powerbash command script
Write-Host "Creating powerbash command..." -ForegroundColor Yellow
$BinDir = "$env:USERPROFILE\.local\bin"
if (-not (Test-Path $BinDir)) {
    New-Item -ItemType Directory -Path $BinDir -Force | Out-Null
}

$PowerBashScript = @"
@echo off
call "$InstallDir\venv\Scripts\activate.bat"
py "$InstallDir\powerbash.py" %*
"@

$PowerBashScript | Out-File -FilePath "$BinDir\powerbash.bat" -Encoding ASCII

# Create PowerShell function
$PowerShellProfile = $PROFILE.CurrentUserAllHosts
$ProfileDir = Split-Path -Parent $PowerShellProfile

if (-not (Test-Path $ProfileDir)) {
    New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
}

# Add to PATH if not already there
$PathToAdd = $BinDir
$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($CurrentPath -notlike "*$PathToAdd*") {
    [Environment]::SetEnvironmentVariable("Path", "$CurrentPath;$PathToAdd", "User")
    Write-Host "Added $PathToAdd to PATH" -ForegroundColor Green
}

# Copy PowerShell module
$ModuleDir = "$env:USERPROFILE\Documents\PowerShell\Modules\PowerBash"
if (-not (Test-Path $ModuleDir)) {
    New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null
}
Copy-Item "$InstallDir\PowerBash.psm1" -Destination "$ModuleDir\PowerBash.psm1" -Force

# Create PowerShell function in profile
$PowerBashFunction = @"

# PowerBash - Bash commands and natural language for PowerShell
# Import module to enable bash commands directly in PowerShell
Import-Module PowerBash -ErrorAction SilentlyContinue

# Interactive shell function (optional - use 'powerbash' command)
function powerbash {
    & "$InstallDir\venv\Scripts\python.exe" "$InstallDir\powerbash.py" $args
}
"@

if (Test-Path $PowerShellProfile) {
    $ProfileContent = Get-Content $PowerShellProfile -Raw
    if ($ProfileContent -notlike "*PowerBash*") {
        Add-Content -Path $PowerShellProfile -Value $PowerBashFunction
        Write-Host "Added PowerBash function to PowerShell profile" -ForegroundColor Green
    } else {
        Write-Host "PowerBash already in PowerShell profile" -ForegroundColor Yellow
    }
} else {
    Set-Content -Path $PowerShellProfile -Value $PowerBashFunction
    Write-Host "Created PowerShell profile with PowerBash function" -ForegroundColor Green
}

Write-Host ""
Write-Host "PowerBash installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Restart PowerShell, then:" -ForegroundColor Cyan
Write-Host ""
Write-Host "Bash commands work automatically:" -ForegroundColor Yellow
Write-Host "   PS> ls                    # Works immediately!" -ForegroundColor Gray
Write-Host "   PS> python3 script.py     # Works immediately!" -ForegroundColor Gray
Write-Host "   PS> cd Documents          # Works immediately!" -ForegroundColor Gray
Write-Host ""
Write-Host "Natural language with 'plz':" -ForegroundColor Yellow
Write-Host "   PS> plz list all python files" -ForegroundColor Gray
Write-Host "   PS> plz git commit with message fixed bug" -ForegroundColor Gray
Write-Host ""
Write-Host "First time setup (for 'plz' commands):" -ForegroundColor Yellow
Write-Host "   PS> plz-setup              # Configure Gemini API key" -ForegroundColor Gray
Write-Host ""
Write-Host "Bash commands: ls, cd, pwd, python3, grep, cat, mkdir, rm, cp, mv, touch, head, tail, clear, nano, vim" -ForegroundColor Cyan
Write-Host ""
