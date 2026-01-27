# PowerBash - Bash Commands & Natural Language for PowerShell

Use bash commands and natural language in PowerShell/Windows Command Prompt.

> **Requirements**: Windows 10+ with PowerShell and Python 3.8+
> 
> **Note**: PowerBash uses the `py` Python launcher (not `python`) for PowerShell compatibility. The `py` command should work automatically on Windows when Python is installed.
> 
> **Security Note**: See [SECURITY.md](SECURITY.md) for privacy and security information, especially if using on a work laptop.

## Features

- 🐚 **Bash Commands in PowerShell**: Use `ls`, `cd`, `python3`, `grep`, etc. **directly in PowerShell** - works automatically!
- 🤖 **Natural Language with `plz`**: Type `plz` before any natural language command to use AI
- ⚡ **PowerShell Native**: All commands are translated to PowerShell equivalents
- 🎯 **Seamless Integration**: Feels like natural PowerShell - no special modes needed

## Install

**Note**: The installer uses the `py` Python launcher (not `python`) for PowerShell compatibility. This is the standard way to access Python on Windows in PowerShell.

### Recommended Method (Download First)

```powershell
# Navigate to your home directory
cd $HOME

# Download the installer
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ammarjmahmood/powerbash/main/install.ps1" -OutFile install.ps1

# Set execution policy (one-time, for this session)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Run the installer
.\install.ps1
```

### Alternative: One-Line Install

```powershell
irm https://raw.githubusercontent.com/ammarjmahmood/powerbash/main/install.ps1 | iex
```

**Note**: If you get an execution policy error with the one-line method, use the recommended method above or run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Uninstall

```powershell
.\uninstall.ps1
```

Or download and run:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ammarjmahmood/powerbash/main/uninstall.ps1" -OutFile uninstall.ps1
.\uninstall.ps1
```

## Usage

After installation, **restart PowerShell** and everything works automatically:

### Bash Commands (Automatic)

Bash commands work directly - no special command needed:

```powershell
PS> ls                    # List files (works immediately!)
PS> cd Documents          # Change directory
PS> python3 script.py     # Run Python
PS> grep "error" log.txt  # Search in file
PS> cat README.md         # View file
PS> touch newfile.txt     # Create file
```

### Natural Language with `plz`

Use `plz` before any natural language command:

```powershell
PS> plz list all python files
→ Get-ChildItem -Recurse -Filter *.py
[Executes automatically]

PS> plz git commit with message fixed bug
→ git commit -m "fixed bug"
[Executes automatically]

PS> plz find all files larger than 100MB
→ Get-ChildItem -Recurse | Where-Object {$_.Length -gt 100MB}
[Executes automatically]
```

**That's it!** No need to run any special command - just use PowerShell naturally.

### Supported Bash Commands (60+ Commands!)

All these work directly in PowerShell (no prefix needed):

**File Operations:**
```powershell
ls, ls -l, ls -a        # List files (with options)
cd, pwd                 # Change/print directory
mkdir, rmdir            # Create/remove directory
rm, cp, mv              # Remove, copy, move files
cat, head, tail         # View file contents
touch                   # Create/update file timestamp
find                    # Find files recursively
which                   # Find command location
```

**Text Processing:**
```powershell
grep "pattern" file     # Search in files
wc file                 # Word count
sort file               # Sort lines
uniq file               # Unique lines
cut -d: -f1 file        # Cut columns
diff file1 file2        # Compare files
echo "text"             # Print text
```

**System Info:**
```powershell
whoami                  # Current user
uname, uname -a         # System info
uptime                  # System uptime
date                    # Current date/time
df, du                  # Disk space
free                    # Memory info
ps, ps -ef              # Process list
kill PID, killall name  # Kill processes
jobs                    # Background jobs
history                 # Command history
```

**Network:**
```powershell
ping hostname           # Ping host
curl URL                # Download/request
wget URL                # Download (alias for curl)
ifconfig                # Network interfaces
netstat -an             # Network connections
```

**Archives:**
```powershell
tar -xzf file.tar.gz    # Extract tar
tar -czf archive.tar files  # Create tar
zip archive.zip files   # Create zip
unzip archive.zip       # Extract zip
```

**Text Utilities:**
```powershell
less file               # Pager (view file)
more file               # Pager (view file)
tee file                # Write to file and stdout
sed 's/old/new/g' file  # Stream editor
tr 'a' 'b'              # Translate characters
man command             # Manual pages
nano file               # Text editor (uses notepad on Windows if nano not available)
vi file                 # Text editor (uses notepad on Windows if vim not available)
vim file                # Text editor (uses notepad on Windows if vim not available)
```

**Path Utilities:**
```powershell
basename /path/file.txt  # Get filename
dirname /path/file.txt   # Get directory
realpath file            # Absolute path
```

**Other:**
```powershell
python3 script.py       # Run Python
clear                   # Clear screen
alias                   # List/set aliases
export VAR=value        # Set environment variable
source script.sh        # Run script
sudo command            # Run as administrator
```

### Natural Language Examples

Use `plz` prefix for natural language:

```powershell
PS> plz show me all text files
PS> plz create a new directory called projects
PS> plz delete all files ending in .tmp
PS> plz what's the current directory?
PS> plz find the largest file in this folder
```

### Setup Commands

- `plz-setup` - Configure your Gemini API key (first time only)

## First Run Setup

1. **Install PowerBash**: Run `.\install.ps1`
2. **Restart PowerShell**
3. **Set up API key** (only needed for `plz` natural language commands):
   ```powershell
   plz-setup
   ```
   Get your free API key from: https://aistudio.google.com/apikey

Bash commands (`ls`, `cd`, `python3`, etc.) work immediately without setup!

## How It Works

1. **Bash Command Translation**: PowerBash recognizes common bash commands and translates them to PowerShell equivalents
2. **Natural Language Processing**: Uses Google's Gemini AI to convert natural language to PowerShell commands
3. **Command Execution**: Runs commands in PowerShell and displays results

## Complete Command List

**60+ bash commands** are preprogrammed and work automatically. Here are the main ones:

| Bash Command | PowerShell Equivalent | Category |
|-------------|----------------------|----------|
| `ls`, `ls -l`, `ls -a` | `Get-ChildItem` | File Ops |
| `cd`, `pwd` | `Set-Location`, `Get-Location` | Navigation |
| `mkdir`, `rm`, `cp`, `mv` | `New-Item`, `Remove-Item`, `Copy-Item`, `Move-Item` | File Ops |
| `cat`, `head`, `tail` | `Get-Content` | Text View |
| `grep`, `wc`, `sort`, `uniq`, `cut`, `diff` | `Select-String`, `Measure-Object`, etc. | Text Proc |
| `find`, `which` | `Get-ChildItem -Recurse`, `Get-Command` | Search |
| `touch` | `New-Item -ItemType File` | File Ops |
| `python3` | `python` | Development |
| `ps`, `kill`, `killall` | `Get-Process`, `Stop-Process` | Process |
| `df`, `du`, `free` | `Get-PSDrive`, `Measure-Object` | System |
| `uptime`, `whoami`, `uname` | `Get-CimInstance`, `$env:USERNAME` | System |
| `ping`, `curl`, `wget` | `Test-Connection`, `Invoke-WebRequest` | Network |
| `ifconfig`, `netstat` | `Get-NetIPAddress`, `Get-NetTCPConnection` | Network |
| `tar`, `zip`, `unzip` | `Compress-Archive`, `Expand-Archive` | Archives |
| `less`, `more`, `tee` | `more`, `Tee-Object` | Text View |
| `sed`, `tr` | String replacement, translation | Text Proc |
| `nano`, `vi`, `vim` | `notepad.exe` (fallback) or native if available | Text Editor |
| `basename`, `dirname`, `realpath` | `Split-Path`, `Resolve-Path` | Path Utils |
| `man`, `sudo` | `Get-Help`, `Start-Process -Verb RunAs` | Utilities |
| `echo`, `date`, `clear` | `Write-Host`, `Get-Date`, `Clear-Host` | Utilities |
| `history`, `alias`, `export`, `source` | `Get-History`, `Set-Alias`, `[Environment]` | Shell |

## Examples

### File Operations
```bash
# List files
ls

# List with details
ls -l

# Change directory
cd Documents/Projects

# Create directory
mkdir newproject

# View file
cat README.md
```

### Python Development
```bash
# Run Python script
python3 app.py

# Install package
pip install requests
```

### Natural Language
```
show me all text files in the current directory
→ Get-ChildItem -Filter *.txt

create a new file called test.txt
→ New-Item -ItemType File -Path test.txt

what's the current directory?
→ Get-Location
```

## Troubleshooting

### "Python is not recognized" or "py is not recognized"
- Install Python from https://www.python.org/
- Make sure to check "Add Python to PATH" during installation
- On Windows, Python is typically accessed via the `py` launcher in PowerShell (not `python`)
- The installer uses `py --version` to check for Python installation

### "Execution policy error"
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "API key error"
- Run `powerbash` and use `!api` to set your API key
- Make sure you have internet connection for AI features

### Commands not working
- Some bash commands may not have direct PowerShell equivalents
- Use `!ps <command>` to run PowerShell commands directly
- Use `!cmd <command>` to run commands directly

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - feel free to use this project for any purpose.

## Acknowledgments

Inspired by [nlsh](https://github.com/junaid-mahmood/nlsh) - Natural Language Shell for macOS/Linux.
