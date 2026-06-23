# MysticaTarot 开发日志

> 项目: MysticaTarot — 占卜塔罗牌 Android APP
> 起始日期: 2026-06-23
> 此文件记录每个开发阶段的完成情况、关键决策与注意事项。

---

## Phase 1: 项目初始化

**完成日期**: 2026-06-23  
**耗时**: 1 天  
**Git Tag**: v0.1.0  

### 完成的功能
- [x] 创建 Flutter 项目 (org: `com.mystica`, Dart包名: `mystica_tarot`)
- [x] 配置 `pubspec.yaml` 依赖（provider, hive, flutter_local_notifications, audioplayers, intl, share_plus 等）
- [x] 建立完整项目目录结构（Feature-First 架构）
- [x] 配置主题系统（玫瑰粉色系 Material Design 3，浅色+深色两套主题）
- [x] 配置 Hive 数据库初始化（4个 Box: settings, reading_history, daily_card, favorites）
- [x] 配置本地化框架（AppLocalizations 三语: en/zh/tl，400+ 翻译条目）
- [x] 配置 `analysis_options.yaml`（Lint 规则）
- [x] 创建 `README.md`（项目介绍、功能列表、技术栈、结构说明）
- [x] 创建 `LICENSE`（MIT 许可证）
- [x] 创建共享 Widgets 库（8个组件: AppScaffold, GradientBackground, MysticalButton, MysticalCard, ParticleEffect, ShimmerLoading, LanguageSelector, SettingsTile）
- [x] 创建核心工具类（DateUtils, RandomUtils, SoundUtils, AppConstants, CardConstants, DivinationConstants）
- [x] 创建核心文件（main.dart, app.dart, AppColors, AppTextStyles, AppTheme, AppRouter）
- [x] 创建功能页面骨架（HomePage + Providers）
- [x] 创建 `docs/` 日志目录（development-log.md, bug-log.md, decision-log.md）
- [x] 初始化 Git 仓库并提交（75 files, 5571 lines）

### 关键技术决策
- **决策**: 使用 Provider + ChangeNotifier 作为状态管理
  **理由**: 项目规模适中，Provider 的 boilerplate 比 Bloc 少，开发效率更高；符合 spec 要求

- **决策**: Feature-First 架构 + MVVM 模式
  **理由**: UI (Widgets) → ViewModel (Provider) → Service → Hive DataSource 的分层清晰，易于扩展

- **决策**: 使用 Map 本地化方案而非 ARB 文件
  **理由**: 三语翻译数据结构简单，Dart Map 直接管理无需额外生成步骤，开发效率更高

- **决策**: 使用 `withValues(alpha:)` 而非 `withOpacity()`
  **理由**: Flutter 3.x 推荐使用 `withValues` API，更符合语义化颜色管理

- **决策**: 采用 198.18.0.8 的 local DNS 隧道环境下，添加 pub.dev 镜像配置指导

### 文件结构变化
- 新增: `lib/` 完整 Feature-First 架构目录（60+ Dart 文件骨架）
- 新增: `docs/` 日志目录（3 个日志文件）
- 新增: `assets/` 资源目录结构（images, sounds, fonts）
- 新增: `resources/l10n/` 本地化资源目录
- 修改: `pubspec.yaml`（完整依赖配置）
- 修改: `analysis_options.yaml`（自定义 Lint 规则）
- 修改: `.gitignore`（放开 docs/*.log 版本控制）
- 修改: `README.md`（项目完整介绍）

### 遗留问题/TODO
- [ ] `flutter pub get` 因 pub.dev DNS 解析问题无法执行（网络环境限制，需用户切换网络或配置镜像）
- [ ] 字体文件（Playfair Display, Noto Serif SC）尚未添加至 assets/fonts/
- [ ] 塔罗牌图片资源尚未添加
- [ ] 音效文件尚未添加
- [ ] 引导页（Onboarding）UI 尚未实现
- [ ] GitHub 远程仓库尚未创建和连接

### 注意事项（给未来自己/协作者）
- Hive 初始化必须在 `runApp` 之前完成，否则会导致 `TypeError`
- 本地化文件使用 `translate()` 方法访问翻译值
- 共享组件位于 `lib/shared/widgets/`，直接复用即可
- 主题系统支持浅色/深色自动切换，通过 `ThemeMode.system` 配置

### 参考资源
- Flutter 3.x Material 3 主题: https://docs.flutter.dev/ui/design/material/material-3
- Provider 状态管理: https://pub.dev/packages/provider
- Hive 数据库: https://pub.dev/packages/hive
- Feature-First 架构: 参见 `.agents/skills/flutter-architecture/SKILL.md`

---
