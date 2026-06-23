@echo off
:: ===================================================================
:: scripts\clean-gradle-cache.bat
::
:: 用途：清理 Gradle + Flutter 本地构建缓存，修复 Kotlin Daemon
::       "Storage for ..tab is already registered" 类并发锁异常。
::
:: 适用：环境已切换阿里云 Gradle 镜像、Gradle 9.1 + AGP 9.0.1 +
::       Kotlin 2.3.20 等 bleed-edge 组合下首次/中途 build 失败。
::
:: 调用：双击运行 或 在 Git Bash / cmd 下 `.\scripts\clean-gradle-cache.bat`
::
:: 影响范围：
::   1. E:\APP\build\                (Flutter 构建产物，含增量 Kotlin .tab)
::   2. E:\APP\.gradle\              (项目级 Gradle cache wrapper)
::   3. %USERPROFILE%\.gradle\caches\build-cache-*\ (cross-project cache)
::   4. %USERPROFILE%\.gradle\caches\journal-1\       (PERSISTENT... file locks)
::
:: 警告：上述路径将全部删除，下次 `flutter run --profile` 会重新缓存所有
::       artifact，第一次 build 会显著变慢 (~3-5 min)。这是预期行为。
:: ===================================================================

setlocal EnableDelayedExpansion

echo.
echo ============================================================
echo  MysticaTarot — Kotlin daemon cache wipe
echo ============================================================
echo.

:: ---- Step 1: 防呆 guard（避免误删 home） ----
if /I "%CD%"=="%USERPROFILE%" (
    echo [ERROR] 不能在 home 目录下运行此脚本！请 cd 到 E:\APP。
    pause
    exit /b 1
)

:: ---- Step 2: 关闭所有 lingering Gradle daemon 避免文件锁冲突 ----
echo [1/4] 停止 Gradle daemon ...
where gradle >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    gradle --stop 2>&1
) else (
    echo        (gradle 不在 PATH 上、跳过 daemon stop)
)

:: ---- Step 3: 删除项目级 build / .gradle ----
echo [2/4] 删除 E:\APP\build\ 和 .gradle\ ...
if exist build (
    rd /s /q build
    echo        OK : build\
) else (
    echo        SKIP: build\ (不存在)
)
if exist .gradle (
    rd /s /q .gradle
    echo        OK : .gradle\
) else (
    echo        SKIP: .gradle\ (不存在)
)

:: ---- Step 4: 删除 user-level Gradle build-cache + journal-1 ----
echo [3/4] 删除 %USERPROFILE%\.gradle\caches\build-cache-* + journal-1\ ...
if exist "%USERPROFILE%\.gradle\caches" (
    for /d %%D in ("%USERPROFILE%\.gradle\caches\build-cache-*") do (
        rd /s /q "%%D"
        echo        OK : %%~nxD
    )
    if exist "%USERPROFILE%\.gradle\caches\journal-1" (
        rd /s /q "%USERPROFILE%\.gradle\caches\journal-1"
        echo        OK : journal-1\
    )
) else (
    echo        SKIP: %USERPROFILE%\.gradle\caches\ (不存在)
)

:: ---- Step 5: 删除 Flutter build artifacts (android sub-build) ----
echo [4/4] 删除 .dart_tool\ + android\app\build\ + ios\build\ ...
if exist .dart_tool\build (
    rd /s /q .dart_tool\build
    echo        OK : .dart_tool\build\
)
if exist android\app\build (
    rd /s /q android\app\build
    echo        OK : android\app\build\
)
if exist ios\Flutter\ephemeral (
    rd /s /q ios\Flutter\ephemeral
    echo        OK : ios\Flutter\ephemeral\
)

echo.
echo ============================================================
echo  Cache wipe 完成。下一步：
echo    1. cd E:\APP
echo    2. .\scripts\profile-android.bat
echo       (脚本会再自动跑 flutter run --profile 并输出到 trace 日志)
echo ============================================================
echo.
pause
endlocal
