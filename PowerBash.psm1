# PowerBash PowerShell Module
# Provides bash command aliases that work directly in PowerShell

# Create enhanced functions for bash commands
function Invoke-ls {
    param([string[]]$Arguments)
    
    $argsStr = $Arguments -join ' '
    
    # Handle -l flag (long format)
    if ($argsStr -match '-l') {
        $filtered = $argsStr -replace '-l', '' -replace '\s+', ' ' | ForEach-Object { $_.Trim() }
        if ($filtered) {
            Get-ChildItem $filtered | Format-List
        } else {
            Get-ChildItem | Format-List
        }
    }
    # Handle -a flag (all files including hidden)
    elseif ($argsStr -match '-a') {
        $filtered = $argsStr -replace '-a', '' -replace '\s+', ' ' | ForEach-Object { $_.Trim() }
        if ($filtered) {
            Get-ChildItem -Force $filtered
        } else {
            Get-ChildItem -Force
        }
    }
    # Handle -la or -al (both flags)
    elseif ($argsStr -match '-la' -or $argsStr -match '-al') {
        $filtered = $argsStr -replace '-la', '' -replace '-al', '' -replace '\s+', ' ' | ForEach-Object { $_.Trim() }
        if ($filtered) {
            Get-ChildItem -Force $filtered | Format-List
        } else {
            Get-ChildItem -Force | Format-List
        }
    }
    # Default behavior
    else {
        if ($Arguments) {
            Get-ChildItem $Arguments
        } else {
            Get-ChildItem
        }
    }
}

function Invoke-python3 {
    param([string[]]$Arguments)
    py $Arguments
}

function Invoke-grep {
    param([string[]]$Arguments)
    Select-String $Arguments
}

function Invoke-touch {
    param([string]$Path)
    if ($Path) {
        if (-not (Test-Path $Path)) {
            New-Item -ItemType File -Path $Path -Force | Out-Null
        } else {
            (Get-Item $Path).LastWriteTime = Get-Date
        }
    }
}

function Invoke-head {
    param([string[]]$Arguments)
    $argsStr = $Arguments -join ' '
    if ($argsStr -match '^-n\s+(\d+)') {
        $count = [int]$matches[1]
        $file = ($argsStr -replace '^-n\s+\d+\s*', '').Trim()
        Get-Content $file -TotalCount $count
    } elseif ($Arguments) {
        Get-Content $Arguments[0] -TotalCount 10
    }
}

function Invoke-tail {
    param([string[]]$Arguments)
    $argsStr = $Arguments -join ' '
    if ($argsStr -match '^-n\s+(\d+)') {
        $count = [int]$matches[1]
        $file = ($argsStr -replace '^-n\s+\d+\s*', '').Trim()
        Get-Content $file -Tail $count
    } elseif ($Arguments) {
        Get-Content $Arguments[0] -Tail 10
    }
}

# Word count
function Invoke-wc {
    param([string[]]$Arguments)
    if ($Arguments) {
        $file = $Arguments[0]
        if (Test-Path $file) {
            $content = Get-Content $file
            $lines = $content.Count
            $words = ($content | Measure-Object -Word).Words
            $chars = ($content | Measure-Object -Character).Characters
            Write-Host "$lines $words $chars $file"
        }
    } else {
        # Count from stdin
        $input = $input | ForEach-Object { $_ }
        $lines = ($input | Measure-Object).Count
        $words = ($input | Measure-Object -Word).Words
        $chars = ($input | Measure-Object -Character).Characters
        Write-Host "$lines $words $chars"
    }
}

# Find files
function Invoke-find {
    param([string[]]$Arguments)
    $argsStr = $Arguments -join ' '
    
    if ($argsStr -match '-name\s+"?([^"]+)"?') {
        $pattern = $matches[1]
        $startPath = if ($Arguments[0] -and $Arguments[0] -ne '-name') { $Arguments[0] } else { '.' }
        Get-ChildItem -Path $startPath -Recurse -Filter $pattern -ErrorAction SilentlyContinue
    } elseif ($argsStr -match '-type\s+([df])') {
        $type = $matches[1]
        $startPath = if ($Arguments[0] -and $Arguments[0] -ne '-type') { $Arguments[0] } else { '.' }
        if ($type -eq 'd') {
            Get-ChildItem -Path $startPath -Recurse -Directory -ErrorAction SilentlyContinue
        } else {
            Get-ChildItem -Path $startPath -Recurse -File -ErrorAction SilentlyContinue
        }
    } else {
        # Default: find all files recursively
        $startPath = if ($Arguments) { $Arguments[0] } else { '.' }
        Get-ChildItem -Path $startPath -Recurse -ErrorAction SilentlyContinue
    }
}

# Which command
function Invoke-which {
    param([string]$Command)
    if ($Command) {
        Get-Command $Command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
    }
}

# Sort
function Invoke-sort {
    param([string[]]$Arguments)
    $argsStr = $Arguments -join ' '
    $reverse = $argsStr -match '-r'
    $numeric = $argsStr -match '-n'
    $unique = $argsStr -match '-u'
    
    if ($Arguments -and (Test-Path $Arguments[-1])) {
        $file = $Arguments[-1]
        $content = Get-Content $file
    } else {
        $content = $input
    }
    
    if ($numeric) {
        $sorted = $content | Sort-Object { [double]$_ }
    } else {
        $sorted = $content | Sort-Object
    }
    
    if ($reverse) {
        $sorted = $sorted | Sort-Object -Descending
    }
    
    if ($unique) {
        $sorted = $sorted | Get-Unique
    }
    
    $sorted
}

# Uniq
function Invoke-uniq {
    param([string[]]$Arguments)
    if ($Arguments -and (Test-Path $Arguments[0])) {
        Get-Content $Arguments[0] | Get-Unique
    } else {
        $input | Get-Unique
    }
}

# Cut
function Invoke-cut {
    param([string[]]$Arguments)
    $argsStr = $Arguments -join ' '
    if ($argsStr -match '-d\s+"?([^"]+)"?\s+-f\s+(\d+)') {
        $delimiter = $matches[1]
        $field = [int]$matches[2]
        if ($Arguments -and (Test-Path $Arguments[-1])) {
            Get-Content $Arguments[-1] | ForEach-Object { ($_ -split $delimiter)[$field - 1] }
        } else {
            $input | ForEach-Object { ($_ -split $delimiter)[$field - 1] }
        }
    } elseif ($argsStr -match '-f\s+(\d+)') {
        $field = [int]$matches[1]
        if ($Arguments -and (Test-Path $Arguments[-1])) {
            Get-Content $Arguments[-1] | ForEach-Object { ($_ -split '\s+')[$field - 1] }
        } else {
            $input | ForEach-Object { ($_ -split '\s+')[$field - 1] }
        }
    }
}

# Diff
function Invoke-diff {
    param([string]$File1, [string]$File2)
    if ($File1 -and $File2) {
        Compare-Object (Get-Content $File1) (Get-Content $File2)
    }
}

# Echo with better support
function Invoke-echo {
    param([string[]]$Arguments)
    $argsStr = $Arguments -join ' '
    # Handle -n flag (no newline)
    if ($argsStr -match '^-n\s+(.+)') {
        Write-Host -NoNewline $matches[1]
    } else {
        Write-Host $argsStr
    }
}

# Date with formatting
function Invoke-date {
    param([string]$Format)
    if ($Format) {
        Get-Date -Format $Format
    } else {
        Get-Date
    }
}

# Uptime
function Invoke-uptime {
    $os = Get-CimInstance Win32_OperatingSystem
    $uptime = (Get-Date) - $os.LastBootUpTime
    Write-Host "up $($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes"
}

# DF (disk free)
function Invoke-df {
    param([string]$Path)
    if ($Path) {
        Get-PSDrive | Where-Object { $_.Root -like "*$Path*" } | Format-Table Name, Used, Free, @{Label="Size";Expression={$_.Used + $_.Free}}
    } else {
        Get-PSDrive -PSProvider FileSystem | Format-Table Name, Used, Free, @{Label="Size";Expression={$_.Used + $_.Free}}
    }
}

# DU (disk usage)
function Invoke-du {
    param([string]$Path)
    $targetPath = if ($Path) { $Path } else { '.' }
    if (Test-Path $targetPath) {
        $size = (Get-ChildItem -Path $targetPath -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $sizeMB = [math]::Round($size / 1MB, 2)
        Write-Host "$sizeMB MB`t$targetPath"
    }
}

# Free (memory info)
function Invoke-free {
    $mem = Get-CimInstance Win32_OperatingSystem
    $total = [math]::Round($mem.TotalVisibleMemorySize / 1MB, 2)
    $free = [math]::Round($mem.FreePhysicalMemory / 1MB, 2)
    $used = $total - $free
    Write-Host "              total        used        free"
    Write-Host "Mem:         $total MB     $used MB     $free MB"
}

# PS (process list)
function Invoke-ps {
    param([string[]]$Arguments)
    $argsStr = $Arguments -join ' '
    if ($argsStr -match '-ef') {
        Get-Process | Format-Table Id, ProcessName, CPU, WorkingSet
    } elseif ($argsStr -match 'aux') {
        Get-Process | Format-Table Id, ProcessName, CPU, @{Label="Memory(MB)";Expression={[math]::Round($_.WorkingSet/1MB,2)}}
    } else {
        Get-Process $Arguments
    }
}

# Kill process
function Invoke-kill {
    param([string[]]$Arguments)
    $argsStr = $Arguments -join ' '
    if ($argsStr -match '-9\s+(\d+)') {
        $pid = [int]$matches[1]
        Stop-Process -Id $pid -Force
    } elseif ($Arguments) {
        $pid = if ($Arguments[0] -match '^\d+$') { [int]$Arguments[0] } else { (Get-Process -Name $Arguments[0]).Id }
        Stop-Process -Id $pid -Force
    }
}

# Killall
function Invoke-killall {
    param([string]$ProcessName)
    if ($ProcessName) {
        Get-Process -Name $ProcessName -ErrorAction SilentlyContinue | Stop-Process -Force
    }
}

# Jobs
function Invoke-jobs {
    Get-Job
}

# History
function Invoke-history {
    param([string[]]$Arguments)
    if ($Arguments -match '^\d+$') {
        Get-History | Select-Object -Last [int]$Arguments[0]
    } else {
        Get-History
    }
}

# Alias
function Invoke-alias {
    param([string]$Name, [string]$Value)
    if ($Name -and $Value) {
        Set-Alias -Name $Name -Value $Value -Scope Global
    } else {
        Get-Alias
    }
}

# Export (set environment variable)
function Invoke-export {
    param([string]$Var)
    if ($Var -match '^(\w+)=(.+)$') {
        $name = $matches[1]
        $value = $matches[2]
        [Environment]::SetEnvironmentVariable($name, $value, "User")
        Set-Item -Path "env:$name" -Value $value
    }
}

# Source / . (run script)
function Invoke-source {
    param([string]$Script)
    if ($Script -and (Test-Path $Script)) {
        & $Script
    }
}

# Uname
function Invoke-uname {
    param([string]$Flag)
    if ($Flag -eq '-a') {
        $os = Get-CimInstance Win32_OperatingSystem
        Write-Host "$($env:COMPUTERNAME) $($os.Caption) $($os.Version)"
    } elseif ($Flag -eq '-r') {
        (Get-CimInstance Win32_OperatingSystem).Version
    } else {
        $env:COMPUTERNAME
    }
}

# Ping
function Invoke-ping {
    param([string[]]$Arguments)
    $target = $Arguments[0]
    if ($target) {
        Test-Connection -ComputerName $target -Count 4
    }
}

# Curl
function Invoke-curl {
    param([string[]]$Arguments)
    $argsStr = $Arguments -join ' '
    if ($argsStr -match '-o\s+"?([^"]+)"?') {
        $output = $matches[1]
        $url = ($Arguments | Where-Object { $_ -notmatch '^-o' })[0]
        Invoke-WebRequest -Uri $url -OutFile $output
    } else {
        $url = $Arguments[0]
        if ($url) {
            (Invoke-WebRequest -Uri $url).Content
        }
    }
}

# Wget
function Invoke-wget {
    param([string[]]$Arguments)
    Invoke-curl $Arguments
}

# Ifconfig / ipconfig
function Invoke-ifconfig {
    Get-NetIPAddress | Format-Table InterfaceAlias, IPAddress, PrefixLength
}

# Netstat
function Invoke-netstat {
    param([string[]]$Arguments)
    $argsStr = $Arguments -join ' '
    if ($argsStr -match '-an') {
        Get-NetTCPConnection | Format-Table LocalAddress, LocalPort, State, RemoteAddress, RemotePort
    } else {
        Get-NetTCPConnection
    }
}

# Tar
function Invoke-tar {
    param([string[]]$Arguments)
    $argsStr = $Arguments -join ' '
    if ($argsStr -match '-xzf\s+"?([^"]+)"?') {
        $archive = $matches[1]
        Expand-Archive -Path $archive -DestinationPath (Get-Location)
    } elseif ($argsStr -match '-czf\s+"?([^"]+)"?\s+(.+)') {
        $archive = $matches[1]
        $files = $matches[2]
        Compress-Archive -Path $files -DestinationPath $archive -Force
    }
}

# Zip
function Invoke-zip {
    param([string[]]$Arguments)
    if ($Arguments.Count -ge 2) {
        $archive = $Arguments[0]
        $files = $Arguments[1..($Arguments.Count-1)] -join ','
        Compress-Archive -Path $files -DestinationPath $archive -Force
    }
}

# Unzip
function Invoke-unzip {
    param([string]$Archive, [string]$Destination)
    if ($Archive) {
        $dest = if ($Destination) { $Destination } else { (Get-Location) }
        Expand-Archive -Path $Archive -DestinationPath $dest -Force
    }
}

# Less / More (pager)
function Invoke-less {
    param([string]$File)
    if ($File -and (Test-Path $File)) {
        Get-Content $File | more
    } else {
        $input | more
    }
}

function Invoke-more {
    param([string]$File)
    if ($File -and (Test-Path $File)) {
        Get-Content $File | more
    } else {
        $input | more
    }
}

# Tee (write to file and stdout)
function Invoke-tee {
    param([string]$File)
    if ($File) {
        $input | Tee-Object -FilePath $File
    } else {
        $input
    }
}

# Basename
function Invoke-basename {
    param([string]$Path, [string]$Suffix)
    if ($Path) {
        $name = Split-Path -Leaf $Path
        if ($Suffix -and $name.EndsWith($Suffix)) {
            $name.Substring(0, $name.Length - $Suffix.Length)
        } else {
            $name
        }
    }
}

# Dirname
function Invoke-dirname {
    param([string]$Path)
    if ($Path) {
        Split-Path -Parent $Path
    }
}

# Realpath (absolute path)
function Invoke-realpath {
    param([string]$Path)
    if ($Path) {
        (Resolve-Path $Path).Path
    } else {
        (Get-Location).Path
    }
}

# Tr (translate characters)
function Invoke-tr {
    param([string[]]$Arguments)
    $argsStr = $Arguments -join ' '
    if ($argsStr -match "'(.+)'\s+'(.+)'") {
        $from = $matches[1]
        $to = $matches[2]
        if ($Arguments -and (Test-Path $Arguments[-1])) {
            (Get-Content $Arguments[-1]) -replace $from, $to
        } else {
            $input -replace $from, $to
        }
    }
}

# Sed (stream editor) - basic support
function Invoke-sed {
    param([string[]]$Arguments)
    $argsStr = $Arguments -join ' '
    if ($argsStr -match "s/(.+)\/(.+)\/g") {
        $pattern = $matches[1]
        $replacement = $matches[2]
        $file = if ($Arguments -and (Test-Path $Arguments[-1])) { $Arguments[-1] } else { $null }
        if ($file) {
            (Get-Content $file) -replace $pattern, $replacement
        } else {
            $input -replace $pattern, $replacement
        }
    }
}

# Man (manual - show PowerShell help)
function Invoke-man {
    param([string]$Command)
    if ($Command) {
        Get-Help $Command -Full
    }
}

# Sudo (run as administrator)
function Invoke-sudo {
    param([string[]]$Arguments)
    if ($Arguments) {
        Start-Process -FilePath $Arguments[0] -ArgumentList ($Arguments[1..($Arguments.Count-1)] -join ' ') -Verb RunAs
    }
}

# Create aliases (these work directly in PowerShell)
Set-Alias -Name ls -Value Invoke-ls -Scope Global -Option AllScope
Set-Alias -Name python3 -Value Invoke-python3 -Scope Global -Option AllScope
Set-Alias -Name grep -Value Invoke-grep -Scope Global -Option AllScope
Set-Alias -Name touch -Value Invoke-touch -Scope Global -Option AllScope
Set-Alias -Name head -Value Invoke-head -Scope Global -Option AllScope
Set-Alias -Name tail -Value Invoke-tail -Scope Global -Option AllScope
Set-Alias -Name wc -Value Invoke-wc -Scope Global -Option AllScope
Set-Alias -Name find -Value Invoke-find -Scope Global -Option AllScope
Set-Alias -Name which -Value Invoke-which -Scope Global -Option AllScope
Set-Alias -Name sort -Value Invoke-sort -Scope Global -Option AllScope
Set-Alias -Name uniq -Value Invoke-uniq -Scope Global -Option AllScope
Set-Alias -Name cut -Value Invoke-cut -Scope Global -Option AllScope
Set-Alias -Name diff -Value Invoke-diff -Scope Global -Option AllScope
Set-Alias -Name echo -Value Invoke-echo -Scope Global -Option AllScope
Set-Alias -Name date -Value Invoke-date -Scope Global -Option AllScope
Set-Alias -Name uptime -Value Invoke-uptime -Scope Global -Option AllScope
Set-Alias -Name df -Value Invoke-df -Scope Global -Option AllScope
Set-Alias -Name du -Value Invoke-du -Scope Global -Option AllScope
Set-Alias -Name free -Value Invoke-free -Scope Global -Option AllScope
Set-Alias -Name ps -Value Invoke-ps -Scope Global -Option AllScope
Set-Alias -Name kill -Value Invoke-kill -Scope Global -Option AllScope
Set-Alias -Name killall -Value Invoke-killall -Scope Global -Option AllScope
Set-Alias -Name jobs -Value Invoke-jobs -Scope Global -Option AllScope
Set-Alias -Name history -Value Invoke-history -Scope Global -Option AllScope
Set-Alias -Name alias -Value Invoke-alias -Scope Global -Option AllScope
Set-Alias -Name export -Value Invoke-export -Scope Global -Option AllScope
Set-Alias -Name source -Value Invoke-source -Scope Global -Option AllScope
Set-Alias -Name uname -Value Invoke-uname -Scope Global -Option AllScope
Set-Alias -Name ping -Value Invoke-ping -Scope Global -Option AllScope
Set-Alias -Name curl -Value Invoke-curl -Scope Global -Option AllScope
Set-Alias -Name wget -Value Invoke-wget -Scope Global -Option AllScope
Set-Alias -Name ifconfig -Value Invoke-ifconfig -Scope Global -Option AllScope
Set-Alias -Name netstat -Value Invoke-netstat -Scope Global -Option AllScope
Set-Alias -Name tar -Value Invoke-tar -Scope Global -Option AllScope
Set-Alias -Name zip -Value Invoke-zip -Scope Global -Option AllScope
Set-Alias -Name unzip -Value Invoke-unzip -Scope Global -Option AllScope
Set-Alias -Name less -Value Invoke-less -Scope Global -Option AllScope
Set-Alias -Name more -Value Invoke-more -Scope Global -Option AllScope
Set-Alias -Name tee -Value Invoke-tee -Scope Global -Option AllScope
Set-Alias -Name basename -Value Invoke-basename -Scope Global -Option AllScope
Set-Alias -Name dirname -Value Invoke-dirname -Scope Global -Option AllScope
Set-Alias -Name realpath -Value Invoke-realpath -Scope Global -Option AllScope
Set-Alias -Name tr -Value Invoke-tr -Scope Global -Option AllScope
Set-Alias -Name sed -Value Invoke-sed -Scope Global -Option AllScope
Set-Alias -Name man -Value Invoke-man -Scope Global -Option AllScope
Set-Alias -Name sudo -Value Invoke-sudo -Scope Global -Option AllScope

# Simple aliases (no function needed)
Set-Alias -Name pwd -Value Get-Location -Scope Global -Option AllScope
Set-Alias -Name clear -Value Clear-Host -Scope Global -Option AllScope
Set-Alias -Name cat -Value Get-Content -Scope Global -Option AllScope

# Whoami function
function Invoke-whoami {
    $env:USERNAME
}
Set-Alias -Name whoami -Value Invoke-whoami -Scope Global -Option AllScope

# Note: cd, mkdir, rm, cp, mv already work in PowerShell with similar syntax
# Note: pushd and popd are built-in PowerShell commands

# Natural Language Function - use 'plz' prefix for AI-powered commands
function plz {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Arguments
    )
    
    if ($Arguments.Count -eq 0) {
        Write-Host "Usage: plz <natural language command>" -ForegroundColor Yellow
        Write-Host "Example: plz list all python files" -ForegroundColor Gray
        return
    }
    
    $naturalLanguage = $Arguments -join ' '
    $script:InstallDir = "$env:USERPROFILE\.powerbash"
    $nlScript = "$script:InstallDir\nl_to_cmd.py"
    $pythonExe = "$script:InstallDir\venv\Scripts\python.exe"
    
    if (-not (Test-Path $pythonExe)) {
        Write-Host "Error: PowerBash not properly installed. Run install.ps1" -ForegroundColor Red
        return
    }
    
    # Call Python script to get command
    try {
        $result = & $pythonExe $nlScript $naturalLanguage 2>&1 | Out-String
        
        # Try to parse JSON
        try {
            $json = $result.Trim() | ConvertFrom-Json
        } catch {
            Write-Host "Error: Failed to parse response from AI service" -ForegroundColor Red
            Write-Host "Raw output: $result" -ForegroundColor Gray
            return
        }
        
        if ($json.error) {
            Write-Host "Error: $($json.error)" -ForegroundColor Red
            if ($json.error -like "*GEMINI_API_KEY*" -or $json.error -like "*API key*") {
                Write-Host "Run 'plz-setup' to configure your API key" -ForegroundColor Yellow
            }
            return
        }
        
        $command = $json.command
        
        if ([string]::IsNullOrWhiteSpace($command)) {
            Write-Host "No command generated" -ForegroundColor Yellow
            return
        }
        
        # Show what will be executed
        Write-Host "→ $command" -ForegroundColor Cyan
        
        # Execute the command
        try {
            Invoke-Expression $command
        } catch {
            Write-Host "Error executing command: $_" -ForegroundColor Red
        }
    } catch {
        Write-Host "Error: Failed to process natural language command" -ForegroundColor Red
        if ($_.Exception.Message) {
            Write-Host $_.Exception.Message -ForegroundColor Red
        }
    }
}

# Setup function for API key
function plz-setup {
    $script:InstallDir = "$env:USERPROFILE\.powerbash"
    $envPath = "$script:InstallDir\.env"
    $pythonExe = "$script:InstallDir\venv\Scripts\python.exe"
    $setupScript = "$script:InstallDir\powerbash.py"
    
    if (-not (Test-Path $pythonExe)) {
        Write-Host "Error: PowerBash not properly installed. Run install.ps1" -ForegroundColor Red
        return
    }
    
    Write-Host ""
    Write-Host "Get your free Gemini API key at: https://aistudio.google.com/apikey" -ForegroundColor Cyan
    Write-Host ""
    $apiKey = Read-Host "Enter your Gemini API key"
    
    if ([string]::IsNullOrWhiteSpace($apiKey)) {
        Write-Host "No API key provided." -ForegroundColor Red
        return
    }
    
    # Save to .env file
    "GEMINI_API_KEY=$apiKey" | Out-File -FilePath $envPath -Encoding ASCII -Force
    Write-Host ""
    Write-Host "✓ API key saved!" -ForegroundColor Green
    Write-Host ""
}

# Export aliases and functions
Export-ModuleMember -Alias ls, python3, grep, touch, head, tail, wc, find, which, sort, uniq, cut, diff, echo, date, uptime, df, du, free, ps, kill, killall, jobs, history, alias, export, source, uname, ping, curl, wget, ifconfig, netstat, tar, zip, unzip, less, more, tee, basename, dirname, realpath, tr, sed, man, sudo, pwd, clear, cat, whoami
Export-ModuleMember -Function Invoke-ls, Invoke-python3, Invoke-grep, Invoke-touch, Invoke-head, Invoke-tail, Invoke-wc, Invoke-find, Invoke-which, Invoke-sort, Invoke-uniq, Invoke-cut, Invoke-diff, Invoke-echo, Invoke-date, Invoke-uptime, Invoke-df, Invoke-du, Invoke-free, Invoke-ps, Invoke-kill, Invoke-killall, Invoke-jobs, Invoke-history, Invoke-alias, Invoke-export, Invoke-source, Invoke-uname, Invoke-ping, Invoke-curl, Invoke-wget, Invoke-ifconfig, Invoke-netstat, Invoke-tar, Invoke-zip, Invoke-unzip, Invoke-less, Invoke-more, Invoke-tee, Invoke-basename, Invoke-dirname, Invoke-realpath, Invoke-tr, Invoke-sed, Invoke-man, Invoke-sudo, Invoke-whoami, plz, plz-setup

# Display welcome message (only once per session)
if (-not $global:PowerBashLoaded) {
    Write-Host "PowerBash loaded! 60+ bash commands work directly. Use 'plz' for natural language." -ForegroundColor Cyan
    Write-Host "Examples: ls, cd, python3, grep, find, ps, kill, curl, tar, zip, wc, sort, diff, sed, less, man" -ForegroundColor Yellow
    $global:PowerBashLoaded = $true
}
