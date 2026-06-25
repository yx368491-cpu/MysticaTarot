# 📜 更新日志 (Changelog)

所有 MysticaTarot 的重要变更均记录在此文件。格式基于 [Keep a Changelog](https://keepachangelog.com/)，版本遵循 [Semantic Versioning](https://semver.org/)。

## [1.0.0] - 2026-06-25

首个公开发布版本。

### ✨ 新增 (Added)

- 🃏 **塔罗占卜** — 完整 78 张 Rider-Waite 塔罗牌，支持 6 种经典牌阵（单张、三牌、凯尔特十字等）
- ⭐ **占星** — 12 星座每日 / 每周 / 每月运势
- 🔢 **灵数学** — 生命路径数、命运数计算与解读
- 🎋 **幸运签** — 模拟传统抽签体验，多种签文等级
- 🎴 **Oracle 指引卡** — 心灵指引与正能量启示
- 📅 **每日抽卡** — 每天自动抽出一张专属塔罗牌
- 📜 **历史记录** — 所有占卜结果本地持久化（Hive），随时回顾
- 🌙 **深色模式** — 浅色 / 深色主题切换
- 🌍 **多语言** — English / Tagalog / 简体中文
- 🔔 **本地通知** — 可选的每日抽卡提醒
- 🎵 **音效与粒子动效** — 营造沉浸式氛围

### 🔧 修复 (Fixed)

- **塔罗历史页始终为空**：`_persistReading` 现在会在占卜完成时调用 `ReadingHistoryProvider.addRecord`，并带有防重复保存 / 防双击的同步门控
- 三处 `use_build_context_synchronously` 静态分析警告：在异步间隔之前捕获 `Navigator.of(context)` 与 Provider 引用，post-await 改用 `State.mounted`
- Hive 还原时 `Map<dynamic, dynamic>` cast 崩溃（详见 `docs/bug-log.md` Bug #004）
- `:app:checkProfileAarMetadata` 因 `flutter_local_notifications` 需要 core library desugaring 启用（详见 `docs/bug-log.md` Bug #006）
- Kotlin Daemon 增量缓存 `Storage already registered`（详见 `docs/bug-log.md` Bug #005）

### 🛠 变更 (Changed)

- App launcher label 由 `mystica_tarot` 改为 `Tarot`，用户在桌面看到真正的产品名
- `docs/profile-traces/` 加入 `.gitignore`（DevTools profile 输出目录）
- `share_plus` 升级至 `^11.0.0`（不再 apply KGP）

### ⚠️ 已知问题 (Known Issues)

- **Android 16 (API 36 / HyperOS) 启动黑屏**：二分法诊断已定位到 OnboardingPage 子组件（详见 `docs/bug-log.md` Bug #008），正在收尾。临时方案：杀进程重进可恢复
- 部分 widget 测试在 Windows 上需要 `@Tags(['slow'])` 隔离；`flutter test --exclude-tags=slow` 用于常规快速测试

### 📦 运行时依赖 (Runtime Dependencies)

| 名称 | 版本 | 用途 |
| --- | --- | --- |
| `provider` | `^6.1.0` | 状态管理 |
| `hive` + `hive_flutter` | `^2.2.3` / `^1.1.0` | 本地存储 |
| `flutter_local_notifications` | `^17.0.0` | 每日抽卡提醒 |
| `audioplayers` | `^6.0.0` | 音效 |
| `intl` + `flutter_localizations` | `^0.20.2` | 国际化 |
| `share_plus` | `^11.0.0` | 内容分享 |
| `cupertino_icons` | `^1.0.8` | 图标字体 |

构建系统：Flutter 3.44.3 / Dart 3.12.2 / AGP 9.0.1 / Kotlin 2.3.20 / Gradle 9.1.0。

## [Unreleased]

暂无。
