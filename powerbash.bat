@echo off
REM PowerBash Launcher for Command Prompt
REM This file should be in your PATH or run from the installation directory

set INSTALL_DIR=%USERPROFILE%\.powerbash

if not exist "%INSTALL_DIR%\venv\Scripts\python.exe" (
    echo PowerBash is not installed. Please run install.ps1 first.
    exit /b 1
)

call "%INSTALL_DIR%\venv\Scripts\activate.bat"
python "%INSTALL_DIR%\powerbash.py" %*
