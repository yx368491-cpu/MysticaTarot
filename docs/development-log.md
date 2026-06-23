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

## Phase 1.5: 资源文件准备

**完成日期**: 2026-06-23  
**耗时**: 同一天（网络问题修复后补充执行）  

### 完成的功能
- [x] 配置 Clash Verge TUN 代理（端口 7897），解决 pub.dev 和 GitHub 网络访问问题
- [x] 修复 Git 配置（切换 master → main 分支）
- [x] 创建 GitHub 远程仓库 `MysticaTarot` 并推送 main + develop 分支
- [x] 使用 Fine-grained Token 认证，配置仓库写入权限
- [x] 使用 `git filter-branch` 从 Git 历史中彻底移除敏感文件（Github API.txt）
- [x] 下载 Playfair Display 可变字体（Regular + Italic，约 560KB）
- [x] 下载 Noto Serif SC 可变字体（Variable，约 11MB）
- [x] 从 Wikimedia Commons 下载全部 78 张 RWS 塔罗牌图片（Geldard 版，22大阿卡纳 + 56小阿卡纳）
- [x] 创建 5 个 JSON 数据文件（major_arcana, minor_arcana, zodiac, fortune_slips, oracle_cards）
- [x] 创建 4 个 WAV 音效占位文件（shuffle, flip, fan, reveal）
- [x] 清理旧 placeholder 文件和重复后缀文件
- [x] flutter analyze — 无问题 / flutter test — 通过
- [x] 提交并推送到 GitHub devleop 分支

### JSON 数据文件详情
| 文件 | 条目 | 内容 |
|------|------|------|
| major_arcana.json | 22 cards | 多语言（英/中/TL）关键词、正逆位解读、爱情/事业/建议 |
| minor_arcana.json | 56 cards | 4花色×14张，含元素、关键词、多语言解读 |
| zodiac_content.json | 12 signs | 星座日期、元素、守护星、性格分析、三语日/周/月运势 |
| fortune_slips.json | 20 slips | 大吉~凶 6等级，多语言签文 |
| oracle_cards_content.json | 40 cards | 多语言指引卡正能量信息 |

### 关键技术决策
- **决策**: 使用 Wikimedia Commons Geldard 版 RWS 塔罗牌图片
  **理由**: 该版本命名统一、色彩还原好，78张完整可用，Public Domain

- **决策**: 使用可变字体（Variable Font）而非静态多文件
  **理由**: Playfair Display 和 Noto Serif SC 的可变版本合并了所有字重，减少 APK 体积

- **决策**: 使用 Fine-grained Token 认证 GitHub
  **理由**: 安全性更高，可精确设置仓库和权限范围

- **决策**: t使用 `curl` 通过代理下载资源，Python 仅用于数据处理
  **理由**: curl 对代理支持和 SSL 处理比 Python urllib 更可靠

### 踩坑记录
- GitHub Push Protection 拦截包含 Token 的初始提交，需用 filter-branch 清理历史
- Wikimedia Commons API 有速率限制（429），需增加 1.5-2s 延迟
- Ace 牌在 Commons 上命名为 "One of" 而非 "Ace of"
- 部分图片下载后出现 `.png.png` 双重扩展名问题，需后处理清理
- Python 在 Windows 下默认 gbk 编码导致 JSON 读取报错，需显式指定 utf-8

### 注意事项
- 字体文件较大（Noto Serif SC 11MB），后续可考虑使用 Google Fonts 动态加载或精简字符集
- 塔罗牌图片为 PNG 格式，后续可转换为 WebP 以减小 APK 体积
- 所有资源文件需确保 pubspec.yaml 中的 assets 声明与实际文件匹配

### 参考资源
- RWS Tarot (Geldard): https://commons.wikimedia.org/wiki/Category:Rider-Waite-Smith_tarot_deck_(Geldard)
- Google Fonts (GitHub): https://github.com/google/fonts
- Clash Verge: D:/Sofeware/Clash Verge/

---

## Phase 2: 塔罗核心功能

**完成日期**: 2026-06-23  
**耗时**: 1 天  
**Git Commits**: `feat: phase 2 tarot core implementation`

### 完成的功能
- [x] 创建域层实体（TarotCard, Spread, SpreadPosition, Reading, CardResult, CardInterpretation, DivinationType 等）
- [x] 实现 JSON 数据加载层（TarotCardContent — 从 assets 加载 major/minor arcana JSON）
- [x] 创建业务服务层（TarotReadingService — 洗牌/抽牌/解读逻辑；SpreadService — 6种牌阵定义）
- [x] 创建 Provider 状态管理（TarotProvider — 牌阵选择/抽牌/揭示/解读全流程；ReadingHistoryProvider — Hive 存储取读记录）
- [x] 开发 TarotHomePage（牌阵选择网格界面，6种牌阵卡片展示）
- [x] 开发 CardDrawPage（3秒洗牌动画 → 逐一翻牌交互，粒子特效背景）
- [x] 开发 ReadingResultPage（完整解读展示 — 正逆位/关键词/爱情/事业/建议，灵性粒子背景）
- [x] 创建 UI Widgets（TarotCardWidget — 牌面展示+图片加载+错误回退；CardBackWidget — 牌背设计；CardFlipAnimation — 3D 翻牌动画；ShuffleAnimation — 洗牌动画+进度条）
- [x] 集成到 HomePage 导航（从首页进入塔罗功能）
- [x] 注册 TarotProvider 到 app.dart 的 MultiProvider widget tree
- [x] flutter analyze — No issues found / flutter test — All tests passed

### 牌阵列表
| 牌阵 | 张数 | 用途 |
|------|------|------|
| 单张牌 (Single Card) | 1 | 快速日常指引 |
| 三张牌 (Three Card) | 3 | 过去-现在-未来 |
| 凯尔特十字 (Celtic Cross) | 10 | 全面人生解读 |
| 关系牌阵 (Relationship) | 5 | 感情关系分析 |
| 选择牌阵 (Decision) | 4 | 决策二选一 |
| 马蹄铁 (Horseshoe) | 7 | 一周运势展望 |

### 关键技术决策
- **决策**: Provider 直接从 TarotCardContent 加载 JSON，跳过 Repository 层
  **理由**: JSON 数据是只读的静态资产，不需要 Repository 的数据源抽象；减少不必要的间接层

- **决策**: ShuffleAnimation 用 AnimationController + StatusListener，与 CardDrawPage 独立计时
  **理由**: 两个组件各自 3 秒，避免竞态条件，代码更清晰

- **决策**: CardFlipAnimationState 公开 flip() 方法
  **理由**: CardDrawPage 需要通过 GlobalKey 控制动画触发，私有状态无法外部访问

- **决策**: 解析使用 Model-View-ViewModel (MVVM) 模式
  **理由**: Provider (ViewModel) 层封装全部业务逻辑，UI 层只消费状态变化

### 文件结构变化
- 新增: `lib/features/tarot/domain/entities/` — 4 个数据模型文件
- 新增: `lib/features/tarot/data/datasources/tarot_card_content.dart` — JSON 加载
- 新增: `lib/features/tarot/services/` — 2 个业务服务
- 新增: `lib/features/tarot/providers/` — 2 个 Provider
- 新增: `lib/features/tarot/presentation/pages/` — 3 个页面
- 新增: `lib/features/tarot/presentation/widgets/` — 4 个组件
- 修改: `lib/app.dart` — 注册 TarotProvider + ReadingHistoryProvider
- 修改: `lib/features/home/presentation/pages/home_page.dart` — 添加导航入口

### 踩坑记录
- JSON asset 路径必须不含 `lib/` 前缀，`rootBundle.loadString()` 使用 `features/tarot/data/json/...`
- `context.mounted` 检查在 `async` 间隙后必须执行，否则可能导航到已dispose的context
- ShuffleAnimation 的 `addStatusListener` 必须在 `_controller.forward()` 之前注册
- `AnimatedBuilder` 是 Flutter 3.x 的正确 widget 名
- MultiProvider 拼写为 `MultiProvider`（大写P）
- `dart fix --apply` 自动修复了 8 处 `prefer_const_constructors` 和 `unnecessary_brace_in_string_interps` 问题

### 注意事项
- 当前音效还未接入（Phase 4），shuffle/flip/reveal 无声音
- 塔罗解读内容目前为英文，多语言显示需要进一步处理
- 洗牌时 TarotProvider 在后台执行随机抽牌，`startReading()` 是异步方法

### 参考资源
- Flutter 动画: https://docs.flutter.dev/ui/animations
- Provider: https://pub.dev/packages/provider
- RWS 塔罗牌: https://en.wikipedia.org/wiki/Rider–Waite_Smith_tarot_deck
