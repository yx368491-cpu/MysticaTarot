# ===================================================================
# scripts\clean-gradle-cache.ps1
#
# 用法：在 Git Bash / PowerShell 下 `.\scripts\clean-gradle-cache.ps1`
#       或双击运行。
#
# 行为与 clean-gradle-cache.bat 一致，PowerShell 实现。
# ===================================================================

# 注：默认 'Continue' 而不是 'Stop'，让单条 Remove-Item 失败（文件被 adb
# / IDE / Daemon 锁住）时不中断全脚本。后面每个 Remove-Item 都包在
# try/catch 中单独处理。
$ErrorActionPreference = 'Continue'

Write-Host ''
Write-Host '============================================================'
Write-Host ' MysticaTarot — Kotlin daemon cache wipe (PowerShell)'
Write-Host '============================================================'
Write-Host ''

# ---- Step 1: 防呆 guard（避免误删 home） ----
$CurrentDir = (Get-Location).Path
$HomeDir = $HOME
if ($CurrentDir -eq $HomeDir) {
    Write-Host '[ERROR] 不能在 home 目录下运行此脚本！请 cd 到 E:\APP。' -ForegroundColor Red
    Read-Host '按 Enter 退出'
    exit 1
}

# ---- Step 2: 关闭 lingering Gradle daemon ----
Write-Host '[1/4] 停止 Gradle daemon ...'
$gradle = Get-Command gradle -ErrorAction SilentlyContinue
if ($gradle) {
    & gradle --stop 2>&1 | Out-Null
    Write-Host '        OK : gradle --stop'
} else {
    Write-Host '        SKIP: gradle 不在 PATH 上'
}

# ---- Step 3: 删除项目级 build / .gradle ----
Write-Host '[2/4] 删除 E:\APP\build\ 和 .gradle\ ...'
foreach ($p in @('build', '.gradle')) {
    try {
        if (Test-Path $p) {
            Remove-Item -Path $p -Recurse -Force -ErrorAction Stop
            Write-Host "        OK : $p\"
        } else {
            Write-Host "        SKIP: $p\ (不存在)"
        }
    } catch {
        Write-Warning "        WARN : 跳过 $p\ ($($_.Exception.Message))"
    }
}

# ---- Step 4: 删除 user-level Gradle build-cache + journal-1 ----
Write-Host '[3/4] 删除 $HOME\.gradle\caches\build-cache-* + journal-1\ ...'
$cacheRoot = Join-Path $HOME '.gradle\caches'
if (Test-Path $cacheRoot) {
    Get-ChildItem -Path $cacheRoot -Directory -Filter 'build-cache-*' -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction Stop
            Write-Host "        OK : $($_.Name)\"
        } catch {
            Write-Warning "        WARN : 跳过 $($_.Name) ($($_.Exception.Message))"
        }
    }
    $journal = Join-Path $cacheRoot 'journal-1'
    try {
        if (Test-Path $journal) {
            Remove-Item -Path $journal -Recurse -Force -ErrorAction Stop
            Write-Host '        OK : journal-1\'
        }
    } catch {
        Write-Warning "        WARN : 跳过 journal-1\ ($($_.Exception.Message))"
    }
} else {
    Write-Host "        SKIP: $HOME\.gradle\caches\ (不存在)"
}

# ---- Step 5: Flutter build artifacts ----
Write-Host '[4/4] 删除 .dart_tool\build\ + android\app\build\ + ios\Flutter\ephemeral\ ...'
foreach ($p in @(
        (Join-Path '.dart_tool' 'build'),
        (Join-Path 'android\app' 'build'),
        (Join-Path 'ios\Flutter' 'ephemeral')
    )) {
    try {
        if (Test-Path $p) {
            Remove-Item -Path $p -Recurse -Force -ErrorAction Stop
            Write-Host "        OK : $p\"
        } else {
            Write-Host "        SKIP: $p\ (不存在)"
        }
    } catch {
        Write-Warning "        WARN : 跳过 $p\ ($($_.Exception.Message)). 关闭 adb / IDE / 后重试。"
    }
}

Write-Host ''
Write-Host '============================================================' -ForegroundColor Cyan
Write-Host ' Cache wipe 完成。下一步：' -ForegroundColor Cyan
Write-Host '   1. cd E:\APP' -ForegroundColor Cyan
Write-Host '   2. .\scripts\profile-android.ps1' -ForegroundColor Cyan
Write-Host '      (脚本会再自动跑 flutter run --profile 并输出到 trace 日志)' -ForegroundColor Cyan
Write-Host '============================================================' -ForegroundColor Cyan
Write-Host ''
Read-Host '按 Enter 退出'
