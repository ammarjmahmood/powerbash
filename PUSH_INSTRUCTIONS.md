# How to Push PowerBash to GitHub

Due to a git repository at your home directory level, you'll need to run the push script manually.

## Option 1: Run the Script (Easiest)

```bash
cd /Users/ammarmahmood/Downloads/powerbash
./push-to-github.sh
```

## Option 2: Manual Git Commands

If the script doesn't work, run these commands manually:

```bash
cd /Users/ammarmahmood/Downloads/powerbash

# Remove any existing .git
rm -rf .git

# Initialize new repo
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: PowerBash - 60+ bash commands and natural language for PowerShell"

# Add remote
git remote add origin https://github.com/ammarjmahmood/powerbash.git

# Rename branch
git branch -M main

# Push
git push -u origin main
```

## Option 3: Use GitHub Desktop or VS Code

1. Open the `powerbash` folder in VS Code or GitHub Desktop
2. Initialize a new repository
3. Commit all files
4. Push to `https://github.com/ammarjmahmood/powerbash.git`

## After Pushing

Once pushed, you can:
- View your repo at: https://github.com/ammarjmahmood/powerbash
- Enable GitHub Pages to host the website (Settings > Pages > Source: main branch > / (root))
- Share the installation command with others
