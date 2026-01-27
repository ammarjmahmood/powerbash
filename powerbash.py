#!/usr/bin/env python3
"""
PowerBash - Natural Language Shell for PowerShell/Windows
Translates bash commands and natural language to PowerShell commands
"""
import signal
import os
import sys
import subprocess
import platform
import re

# Windows-specific imports
try:
    import readline
except ImportError:
    # Windows doesn't have readline by default, use pyreadline3 if available
    try:
        import pyreadline3 as readline
    except ImportError:
        readline = None

def exit_handler(sig, frame):
    print()
    raise InterruptedError()

if platform.system() != "Windows":
    signal.signal(signal.SIGINT, exit_handler)

script_dir = os.path.dirname(os.path.abspath(__file__))
env_path = os.path.join(script_dir, ".env")

def load_env():
    """Load environment variables from .env file"""
    if os.path.exists(env_path):
        with open(env_path, encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#") and "=" in line:
                    key, value = line.split("=", 1)
                    os.environ[key] = value

def save_api_key(api_key: str):
    """Save API key to .env file"""
    with open(env_path, "w", encoding='utf-8') as f:
        f.write(f"GEMINI_API_KEY={api_key}\n")

def setup_api_key():
    """Setup Gemini API key"""
    print(f"\n\033[36mGet your free key at: https://aistudio.google.com/apikey\033[0m\n")
    api_key = input("\033[33mEnter your Gemini API key:\033[0m ").strip()
    if not api_key:
        print("No API key provided.")
        sys.exit(1)
    save_api_key(api_key)
    os.environ["GEMINI_API_KEY"] = api_key
    print("\033[32m✓ API key saved!\033[0m\n")

def show_help():
    """Display help information"""
    print("\033[36m!api\033[0m - Change API key")
    print("\033[36m!uninstall\033[0m - Remove powerbash")
    print("\033[36m!help\033[0m - Show this help")
    print("\033[36m!cmd\033[0m - Run cmd directly")
    print("\033[36m!ps\033[0m - Run PowerShell command directly")
    print()

# Bash to PowerShell command mappings
BASH_TO_PS_MAPPINGS = {
    # File operations
    r'^ls\s': 'Get-ChildItem',
    r'^ls$': 'Get-ChildItem',
    r'^pwd$': 'Get-Location',
    r'^cd\s': 'Set-Location',
    r'^cd$': 'Set-Location ~',
    r'^mkdir\s': 'New-Item -ItemType Directory -Path',
    r'^rm\s': 'Remove-Item',
    r'^rmdir\s': 'Remove-Item',
    r'^cp\s': 'Copy-Item',
    r'^mv\s': 'Move-Item',
    r'^cat\s': 'Get-Content',
    r'^touch\s': 'New-Item -ItemType File -Path',
    r'^head\s': 'Get-Content -TotalCount',
    r'^tail\s': 'Get-Content -Tail',
    
    # Python
    r'^python3\s': 'python',
    r'^python3$': 'python',
    
    # System
    r'^clear$': 'Clear-Host',
    r'^whoami$': 'whoami',
    r'^date$': 'Get-Date',
    r'^echo\s': 'Write-Output',
    
    # Search
    r'^grep\s': 'Select-String',
    r'^find\s': 'Get-ChildItem -Recurse -Filter',
    
    # Process
    r'^ps\s': 'Get-Process',
    r'^kill\s': 'Stop-Process',
}

def translate_bash_to_powershell(command: str) -> str:
    """Translate bash commands to PowerShell equivalents"""
    original = command.strip()
    
    # Handle pipes
    if '|' in original:
        parts = original.split('|')
        translated_parts = []
        for part in parts:
            translated_parts.append(translate_bash_to_powershell(part.strip()))
        return ' | '.join(translated_parts)
    
    # Handle && and ||
    if '&&' in original:
        parts = original.split('&&')
        translated_parts = []
        for part in parts:
            translated_parts.append(translate_bash_to_powershell(part.strip()))
        return '; '.join(translated_parts)
    
    # Handle redirection
    if '>>' in original:
        parts = original.split('>>', 1)
        cmd = translate_bash_to_powershell(parts[0].strip())
        file = parts[1].strip()
        return f'{cmd} | Out-File -Append -FilePath {file}'
    
    if '>' in original and '>>' not in original:
        parts = original.split('>', 1)
        cmd = translate_bash_to_powershell(parts[0].strip())
        file = parts[1].strip()
        return f'{cmd} | Out-File -FilePath {file}'
    
    # Check for exact matches first
    for pattern, replacement in BASH_TO_PS_MAPPINGS.items():
        if re.match(pattern, original):
            if replacement.endswith(' '):
                # Replace the command but keep the rest
                return original.replace(re.match(pattern, original).group(0), replacement)
            else:
                # Full replacement
                return replacement
    
    # Handle ls with options
    if original.startswith('ls '):
        args = original[3:].strip()
        if args.startswith('-'):
            # Convert common ls flags
            args = args.replace('-l', ' | Format-List')
            args = args.replace('-a', ' -Force')
            args = args.replace('-h', '')
            return f'Get-ChildItem {args}'
        return f'Get-ChildItem {args}'
    
    # Handle cd with path expansion
    if original.startswith('cd '):
        path = original[3:].strip()
        path = os.path.expanduser(path) if '~' in path else path
        return f'Set-Location "{path}"'
    
    # Handle python3
    if original.startswith('python3 '):
        return original.replace('python3 ', 'python ', 1)
    
    # If no translation found, return original (might be PowerShell already)
    return original

def is_bash_command(text: str) -> bool:
    """Check if text looks like a bash command that needs translation"""
    bash_commands = ['ls', 'pwd', 'cd', 'mkdir', 'rm', 'cp', 'mv', 'cat', 
                     'touch', 'head', 'tail', 'grep', 'find', 'python3',
                     'clear', 'echo', 'ps', 'kill']
    return any(text.strip().startswith(cmd + ' ') or text.strip() == cmd 
               for cmd in bash_commands)

def is_natural_language(text: str) -> bool:
    """Check if text is natural language vs a command"""
    if text.startswith("!"):
        return False
    
    # Check if it's a bash command
    if is_bash_command(text):
        return False
    
    # Check if it's a PowerShell command
    ps_commands = ['Get-', 'Set-', 'New-', 'Remove-', 'Copy-', 'Move-',
                   'Select-', 'Where-', 'ForEach-', 'Invoke-', 'Test-']
    if any(text.startswith(cmd) for cmd in ps_commands):
        return False
    
    # Check for common command patterns
    shell_starters = ['git ', 'npm ', 'node ', 'npx ', 'python ', 'pip ',
                      'docker ', 'kubectl ', 'aws ', 'az ', 'curl ', 
                      'wget ', 'chmod ', 'chown ', 'sudo ', 'code ',
                      './', '/', '~', '$', '>', '>>', '|', '&&']
    
    return not any(text.startswith(s) for s in shell_starters)

load_env()

first_run = not os.getenv("GEMINI_API_KEY")
if first_run:
    setup_api_key()
    print("\033[1mPowerBash\033[0m - bash commands and natural language for PowerShell\n")
    show_help()

try:
    from google import genai
    client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))
except ImportError:
    print("\033[31mError: google-genai package not installed. Run: pip install google-genai\033[0m")
    sys.exit(1)

command_history = []
MAX_HISTORY = 10
MAX_CONTEXT_CHARS = 4000

def get_context_size() -> int:
    """Calculate total context size"""
    return sum(len(e["command"]) + len(e["output"]) for e in command_history)

def add_to_history(command: str, output: str = ""):
    """Add command to history"""
    command_history.append({
        "command": command,
        "output": output[:500] if output else ""
    })
    while len(command_history) > MAX_HISTORY:
        command_history.pop(0)
    while get_context_size() > MAX_CONTEXT_CHARS and len(command_history) > 1:
        command_history.pop(0)

def format_history() -> str:
    """Format command history for context"""
    if not command_history:
        return "No previous commands."
    
    lines = []
    for i, entry in enumerate(command_history[-5:], 1):
        lines.append(f"{i}. $ {entry['command']}")
        if entry['output']:
            output_lines = entry['output'].strip().split('\n')[:2]
            for line in output_lines:
                lines.append(f"   {line}")
    return "\n".join(lines)

def get_command(user_input: str, cwd: str) -> str:
    """Use AI to convert natural language to PowerShell command"""
    history_context = format_history()
    prompt = f"""You are a PowerShell command translator. Convert the user's request into a PowerShell command for Windows.
Current directory: {cwd}

Recent command history:
{history_context}

Rules:
- Output ONLY the PowerShell command, nothing else
- No explanations, no markdown, no backticks
- If unclear, make a reasonable assumption
- Prefer simple, common PowerShell commands
- Use the command history for context (e.g., "do that again", "delete the file I just created")
- For file operations, use PowerShell cmdlets like Get-ChildItem, Set-Location, etc.

User request: {user_input}"""

    try:
        response = client.models.generate_content(
            model="gemini-2.5-flash",
            contents=prompt
        )
        return response.text.strip()
    except Exception as e:
        if "429" in str(e) or "quota" in str(e).lower():
            raise Exception("rate limit hit - wait a moment and try again")
        raise

def run_powershell_command(command: str) -> tuple[str, str]:
    """Execute a PowerShell command and return output"""
    try:
        # Use PowerShell to execute the command
        if platform.system() == "Windows":
            result = subprocess.run(
                ["powershell", "-Command", command],
                capture_output=True,
                text=True,
                encoding='utf-8',
                errors='replace'
            )
        else:
            # For testing on non-Windows systems
            result = subprocess.run(
                command,
                shell=True,
                capture_output=True,
                text=True,
                encoding='utf-8',
                errors='replace'
            )
        return result.stdout, result.stderr
    except Exception as e:
        return "", str(e)

def main():
    """Main interactive loop"""
    while True:
        try:
            cwd = os.getcwd()
            prompt = f"\033[32m{os.path.basename(cwd)}\033[0m > "
            user_input = input(prompt).strip()
            
            if not user_input:
                continue
            
            # Handle cd command specially
            if user_input.startswith("cd "):
                path = os.path.expanduser(user_input[3:].strip())
                try:
                    os.chdir(path)
                except Exception as e:
                    print(f"cd: {e}")
                continue
            elif user_input == "cd":
                os.chdir(os.path.expanduser("~"))
                continue
            
            # Handle special commands
            if user_input == "!api":
                setup_api_key()
                global client
                client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))
                continue
            
            if user_input == "!uninstall":
                confirm = input("\033[33mRemove powerbash? [y/N]\033[0m ")
                if confirm.lower() == "y":
                    import shutil
                    install_dir = os.path.expanduser("~/.powerbash")
                    if os.path.exists(install_dir):
                        shutil.rmtree(install_dir)
                    print("\033[32m✓ powerbash uninstalled\033[0m")
                    print("You may need to remove the PATH entry manually from your PowerShell profile.")
                    sys.exit(0)
                continue
            
            if user_input == "!help":
                show_help()
                continue
            
            # Direct command execution with !
            if user_input.startswith("!"):
                cmd = user_input[1:]
                if not cmd:
                    continue
                stdout, stderr = run_powershell_command(cmd)
                print(stdout, end="")
                if stderr:
                    print(stderr, end="", file=sys.stderr)
                add_to_history(cmd, stdout + stderr)
                continue
            
            # Direct PowerShell command execution with !ps
            if user_input.startswith("!ps "):
                cmd = user_input[4:]
                stdout, stderr = run_powershell_command(cmd)
                print(stdout, end="")
                if stderr:
                    print(stderr, end="", file=sys.stderr)
                add_to_history(cmd, stdout + stderr)
                continue
            
            # Check if it's a bash command that needs translation
            if is_bash_command(user_input):
                ps_command = translate_bash_to_powershell(user_input)
                confirm = input(f"\033[33m→ {ps_command}\033[0m [Enter] ")
                
                if confirm == "":
                    if ps_command.startswith("Set-Location"):
                        # Extract path from Set-Location command
                        path_match = re.search(r'Set-Location\s+"?([^"]+)"?', ps_command)
                        if path_match:
                            path = path_match.group(1)
                            try:
                                os.chdir(path)
                            except Exception as e:
                                print(f"cd: {e}")
                    else:
                        stdout, stderr = run_powershell_command(ps_command)
                        print(stdout, end="")
                        if stderr:
                            print(stderr, end="", file=sys.stderr)
                        add_to_history(ps_command, stdout + stderr)
                continue
            
            # Check if it's a direct command (not natural language)
            if not is_natural_language(user_input):
                stdout, stderr = run_powershell_command(user_input)
                print(stdout, end="")
                if stderr:
                    print(stderr, end="", file=sys.stderr)
                add_to_history(user_input, stdout + stderr)
                continue
            
            # Natural language processing
            try:
                command = get_command(user_input, cwd)
                confirm = input(f"\033[33m→ {command}\033[0m [Enter] ")
                
                if confirm == "":
                    if command.startswith("Set-Location"):
                        path_match = re.search(r'Set-Location\s+"?([^"]+)"?', command)
                        if path_match:
                            path = path_match.group(1)
                            try:
                                os.chdir(path)
                            except Exception as e:
                                print(f"cd: {e}")
                    else:
                        stdout, stderr = run_powershell_command(command)
                        print(stdout, end="")
                        if stderr:
                            print(stderr, end="", file=sys.stderr)
                        add_to_history(command, stdout + stderr)
            except Exception as e:
                err = str(e)
                if "rate limit" in err.lower():
                    print(f"\033[31m{err}\033[0m")
                else:
                    print(f"\033[31merror: {err[:100]}\033[0m")
        
        except (EOFError, InterruptedError, KeyboardInterrupt):
            print("\nExiting...")
            break
        except Exception as e:
            err = str(e)
            if "InterruptedError" not in err and "KeyboardInterrupt" not in err:
                print(f"\033[31merror: {err[:100]}\033[0m")

if __name__ == "__main__":
    main()
