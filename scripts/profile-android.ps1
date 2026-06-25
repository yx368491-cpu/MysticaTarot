# Phase 8 P0: Real-device Flutter DevTools profile launcher (PowerShell).
# Equivalent to scripts/profile-android.bat but idiomatic for PowerShell hosts.
#
# Run from E:\APP:
#   powershell -ExecutionPolicy Bypass -File scripts\profile-android.ps1

$ErrorActionPreference = 'Stop'

function Require-Command {
    param([string]$Name)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        Write-Host "ERROR: $Name not on PATH. Aborting." -ForegroundColor Red
        exit 1
    }
}

# 1. Pre-flight
Write-Host "=== Pre-flight checks ===" -ForegroundColor Cyan
Require-Command adb
Require-Command flutter

# 2. adb device
Write-Host "=== adb devices ===" -ForegroundColor Cyan
& adb devices
$deviceList = & adb devices | Select-String -Pattern 'device$'
if (-not $deviceList) {
    Write-Host "ERROR: No device attached. Plug in your phone and retry." -ForegroundColor Red
    exit 1
}
# Split on any whitespace run (matches both adb devices and adb devices -l
# output formats); takes the first token = serial. Earlier `-split "`t"`
# only worked on tab-separated output and produced the entire line when
# Select-String returned a MatchInfo, so `-d $DEVICE` would have been
# rejected by flutter with a malformed serial.
$DEVICE = ($deviceList -split '\s+')[0]
Write-Host "Device detected: $DEVICE" -ForegroundColor Green

# 3. Trace output dir
$today = Get-Date -Format 'yyyy-MM-dd'
$traceDir = "docs\profile-traces\$today"
if (-not (Test-Path $traceDir)) { New-Item -ItemType Directory -Path $traceDir | Out-Null }

# 4. Battery baseline reset
Write-Host "=== Resetting batterystats baseline ===" -ForegroundColor Cyan
& adb shell dumpsys batterystats --reset

# 5. Run app in Profile mode
Write-Host "=== Launching flutter run --profile ===" -ForegroundColor Cyan
Write-Host "Press 'v' to open DevTools in the browser."
Write-Host "Then follow docs\profiling-recipe.md Steps 3-6 for performance trace."
Write-Host ""
& flutter run --profile -d $DEVICE 2>&1 | Tee-Object -FilePath "$traceDir\flutter-run.log"
$RC = $LASTEXITCODE
Write-Host ""
Write-Host "=== Done (flutter exit code: $RC) ===" -ForegroundColor Cyan
Write-Host "Trace log: $traceDir\flutter-run.log"
Write-Host ""
# Pause so a double-clicked PowerShell host doesn't vanish the trace log path.
Read-Host "Press Enter to exit"
