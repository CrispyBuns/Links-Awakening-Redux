@echo off
setlocal enabledelayedexpansion

set "RGBDS_VERSION=0.9.4"
set "RGBDS_DIR=rgbds"

set "WIN64_URL=https://github.com/gbdev/rgbds/releases/download/v%RGBDS_VERSION%/rgbds-win64.zip"
set "WIN32_URL=https://github.com/gbdev/rgbds/releases/download/v%RGBDS_VERSION%/rgbds-win32.zip"

:: Detect if script is running interactively
set "INTERACTIVE=1"
if not exist "%CONIN%" set "INTERACTIVE=0"

echo Detecting operating system...

:: Detect 64-bit or 32-bit Windows
if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set "OS=win64"
) else (
    set "OS=win32"
)

echo Detected OS: %OS%

:: Check for PowerShell
where powershell >nul 2>&1
if errorlevel 1 (
    echo PowerShell is required to run this script.
    echo Please install PowerShell and try again.
    if "%INTERACTIVE%"=="1" pause
    exit /b 1
)

:: Remove existing folder if present
if exist "%RGBDS_DIR%" (
    echo Removing existing "%RGBDS_DIR%" directory...
    rmdir /s /q "%RGBDS_DIR%"
)

mkdir "%RGBDS_DIR%"
cd "%RGBDS_DIR%"

echo Downloading RGBDS %RGBDS_VERSION% for %OS%...

if "%OS%"=="win64" (
    set "URL=%WIN64_URL%"
) else (
    set "URL=%WIN32_URL%"
)

for %%A in ("%URL%") do (
    set "FILENAME=%%~nxA"
)

powershell -Command "Invoke-WebRequest '%URL%' -OutFile '%FILENAME%'"

if not exist "%FILENAME%" (
    echo Download failed. Please check your internet connection.
    if "%INTERACTIVE%"=="1" pause
    exit /b 1
)

echo Extracting...
powershell -Command "Expand-Archive -Force '%FILENAME%' ."

if errorlevel 1 (
    echo Extraction failed.
    if "%INTERACTIVE%"=="1" pause
    exit /b 1
)

echo Cleaning up...
del "%FILENAME%"

echo RGBDS %RGBDS_VERSION% successfully installed in '%RGBDS_DIR%'.

if "%INTERACTIVE%"=="1" pause
endlocal
