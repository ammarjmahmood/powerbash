# Security & Privacy Information

## Overview

This document explains what data PowerBash collects, stores, and transmits to help you make an informed decision about using it on your work laptop.

## Data Transmission

### When using `plz` (Natural Language Commands)

**Data sent to Google's Gemini API:**
- ✅ **Your natural language request** (e.g., "list all python files")
- ✅ **Current working directory path** (e.g., `C:\Users\YourName\Documents`)
- ⚠️ **Recent command history** (last 5-10 commands you ran)

**What is NOT sent:**
- ❌ File contents
- ❌ Usernames or personal info (except what's in directory paths)
- ❌ System information beyond current directory
- ❌ Your API key (it's only used for authentication)

**Example of what gets sent:**
```
Current directory: C:\Users\John\Documents\Projects
Recent command history:
1. $ ls
2. $ cd Documents

User request: list all python files
```

### When using Bash Commands (ls, cd, etc.)

**No data is transmitted** - all bash commands are preprogrammed and run locally. They don't use any AI or external services.

## Data Storage

### Local Storage (Your Computer Only)

1. **API Key** (`~/.powerbash/.env`)
   - Stored in plain text in your user directory
   - Only used to authenticate with Google's API
   - Never shared or uploaded anywhere

2. **Command History** (`~/.powerbash/.powerbash_history`) - Optional
   - Only created if you use the interactive shell mode
   - Contains last 10 commands
   - Used only for context in `plz` commands
   - Stored locally, never transmitted

3. **PowerShell Module** (`Documents\PowerShell\Modules\PowerBash`)
   - Just the code files
   - No personal data

## Security Considerations

### ✅ Safe to Use

- **Bash commands work 100% locally** - no network calls
- **API key stored locally** - not shared with anyone
- **No file contents sent** - only directory paths and command history
- **No remote code execution** - all commands run on your machine
- **Open source** - you can review all code

### ⚠️ Considerations for Work Laptops

1. **Corporate IT Policies**
   - May prohibit installing software/modules
   - May block external API calls (Google Gemini)
   - May require admin approval for Python/pip installations
   - **Check with your IT department first**

2. **Data Privacy**
   - Directory paths sent to Google may reveal:
     - Project names
     - Folder structure
     - Usernames (in paths)
   - Command history may contain:
     - File names you're working with
     - Commands you've run
   - **Google's privacy policy applies** to data sent to Gemini API

3. **Network Traffic**
   - `plz` commands make HTTPS requests to Google's servers
   - May be logged by corporate firewalls/proxies
   - Bash commands (ls, cd, etc.) have **zero network traffic**

## Recommendations

### For Work Laptops

1. **Ask IT First**
   - Check if installing PowerShell modules is allowed
   - Verify if external API calls are permitted
   - Confirm Python installation policy

2. **Use Bash Commands Only** (Safest Option)
   - All 50+ bash commands work without any AI/network calls
   - Just don't use `plz` command
   - Zero data transmission, zero privacy concerns

3. **If Using `plz` Command**
   - Be aware directory paths are sent to Google
   - Avoid using `plz` with sensitive directory names
   - Consider using generic folder names for work projects

4. **API Key Security**
   - Your API key is stored locally in `.env` file
   - Don't share this file or commit it to git
   - If laptop is shared, consider file permissions

## How to Use Safely

### Option 1: Bash Commands Only (No AI, No Data Transmission)
```powershell
# These work 100% locally, no network calls
ls, cd, python3, grep, find, ps, kill, etc.
```

### Option 2: Disable AI Features
If you install but don't run `plz-setup`, the `plz` command won't work, but all bash commands will still work perfectly.

### Option 3: Review Before Sending
The code is open source - you can review exactly what gets sent before using `plz`.

## Google Gemini API Privacy

When you use `plz`, data is sent to Google's Gemini API. According to Google's privacy policy:
- Data may be used to improve their services
- Data may be stored temporarily
- Review Google's privacy policy: https://policies.google.com/privacy

## Comparison

| Feature | Data Sent | Network Calls | Privacy Risk |
|---------|-----------|---------------|--------------|
| Bash commands (ls, cd, etc.) | None | None | ✅ None |
| `plz` natural language | Directory path, command history | Yes (HTTPS) | ⚠️ Low-Medium |

## Questions?

- **No data transmission?** Use only bash commands (ls, cd, python3, etc.)
- **Want AI features?** Understand that directory paths and command history are sent to Google
- **Corporate laptop?** Check with IT first, or use bash commands only

## Summary

- ✅ **Bash commands are 100% safe** - no data transmission, no network calls
- ⚠️ **`plz` command sends data to Google** - directory paths and command history
- ✅ **API key stored locally** - never shared
- ⚠️ **Check corporate policies** before installing on work laptop
- ✅ **Open source** - review code yourself
