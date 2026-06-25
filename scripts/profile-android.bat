@echo off
REM Phase 8 P0: Real-device Flutter DevTools profile launcher.
REM Run this on your Windows dev machine after plugging a 6GB+ Android
REM phone (developer mode + USB debugging enabled). Output traces are
REM dropped under docs\profile-traces\YYYY-MM-DD\ for diff comparison
REM across runs.
REM
REM Usage (from E:\APP):
REM   scripts\profile-android.bat
REM
REM Docs: docs\profiling-recipe.md (the recipe this script implements)
REM       docs\phase7-startup-checklist.md (the optimization checklist
REM       to invoke once you have a trace).

setlocal

REM --- 1. Pre-flight checks ---
echo === Pre-flight checks ===
where adb >nul 2>nul
if errorlevel 1 (
  echo ERROR: adb not on PATH. Install Android platform-tools and retry.
  exit /b 1
)
where flutter >nul 2>nul
if errorlevel 1 (
  echo ERROR: flutter not on PATH. Install Flutter SDK and retry.
  exit /b 1
)

REM --- 2. adb device check ---
echo === adb devices ===
adb devices
for /f "tokens=1,2" %%a in ('adb devices ^| findstr /R "device$"') do set DEVICE=%%a
if not defined DEVICE (
  echo ERROR: No device attached. Plug in your phone and re-try.
  exit /b 1
)
echo Device detected: %DEVICE%

REM --- 3. Trace output directory ---
REM wmic was removed in Windows 11 24H2. Use PowerShell Get-Date instead.
for /f "delims=" %%a in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"') do set "DATETIME=%%a"
set TRACE_DATE=%DATETIME:~0,4%-%DATETIME:~4,2%-%DATETIME:~6,2%
REM mkdir can't create intermediate parents — make sure
REM docs\profile-traces\ itself exists before the dated subdir.
if not exist docs\profile-traces mkdir docs\profile-traces
set TRACE_DIR=docs\profile-traces\%TRACE_DATE%
if not exist %TRACE_DIR% mkdir %TRACE_DIR%

REM --- 4. Battery baseline reset ---
echo === Resetting batterystats baseline ===
adb shell dumpsys batterystats --reset

REM --- 5. Run app in Profile mode ---
echo === Launching flutter run --profile ===
echo Press 'v' in this terminal once connected to open DevTools.
echo Then follow docs\profiling-recipe.md Step 3-6 for the actual
echo performance trace workflow.
echo.
flutter run --profile -d %DEVICE% 2>&1 | tee %TRACE_DIR%\flutter-run.log
set RC=%ERRORLEVEL%
echo.
echo === Done (flutter exit code: %RC%) ===
echo Trace log: %TRACE_DIR%\flutter-run.log
echo.
REM --- 6. Pause so a double-clicked terminal doesn't vanish ---
pause
