#!/usr/bin/env python3
"""
Helper script to convert natural language to PowerShell commands
Called by PowerShell 'plz' function
"""
import os
import sys
import json
from pathlib import Path

# Load environment
script_dir = Path(__file__).parent
env_path = script_dir / ".env"

if env_path.exists():
    with open(env_path, encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                key, value = line.split("=", 1)
                os.environ[key] = value

try:
    from google import genai
except ImportError:
    print(json.dumps({"error": "google-genai package not installed"}))
    sys.exit(1)

def get_command(user_input: str, cwd: str, history: list = None) -> str:
    """Use AI to convert natural language to PowerShell command"""
    if history is None:
        history = []
    
    history_context = ""
    if history:
        history_lines = []
        for i, entry in enumerate(history[-5:], 1):
            history_lines.append(f"{i}. $ {entry}")
        history_context = "\nRecent command history:\n" + "\n".join(history_lines)
    
    prompt = f"""You are a PowerShell command translator. Convert the user's request into a PowerShell command for Windows.
Current directory: {cwd}
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
        api_key = os.getenv("GEMINI_API_KEY")
        if not api_key:
            return json.dumps({"error": "GEMINI_API_KEY not set. Run 'plz-setup' first."})
        
        client = genai.Client(api_key=api_key)
        response = client.models.generate_content(
            model="gemini-2.5-flash",
            contents=prompt
        )
        command = response.text.strip()
        return json.dumps({"command": command})
    except Exception as e:
        error_msg = str(e)
        if "429" in error_msg or "quota" in error_msg.lower():
            return json.dumps({"error": "Rate limit hit - wait a moment and try again"})
        return json.dumps({"error": error_msg[:200]})

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(json.dumps({"error": "Usage: nl_to_cmd.py <natural language>"}))
        sys.exit(1)
    
    user_input = " ".join(sys.argv[1:])
    cwd = os.getcwd()
    
    # Try to get history from environment or file (optional)
    history = []
    history_file = script_dir / ".powerbash_history"
    if history_file.exists():
        try:
            with open(history_file, encoding='utf-8') as f:
                history = [line.strip() for line in f.readlines()[-10:]]
        except:
            pass
    
    result = get_command(user_input, cwd, history)
    print(result)
