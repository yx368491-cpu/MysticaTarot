# 占卜塔罗牌 APP 完整开发规格文档

> **文档版本**: v1.0  
> **创建日期**: 2026-06-22  
> **目标平台**: Android (Flutter)  
> **开发模式**: 个人开发者  

---

## 目录

1. [项目概述](#1-项目概述)
2. [技术栈](#2-技术栈)
3. [项目架构](#3-项目架构)
4. [功能规格](#4-功能规格)
5. [页面与导航](#5-页面与导航)
6. [数据模型](#6-数据模型)
7. [UI/UX 设计](#7-uiux-设计)
8. [本地化 (i18n)](#8-本地化-i18n)
9. [本地存储方案](#9-本地存储方案)
10. [Git 工作流](#10-git-工作流)
11. [开发路线图](#11-开发路线图)
12. [文件结构](#12-文件结构)
13. [日志与问题追踪系统](#13-日志与问题追踪系统)

---

## 1. 项目概述

### 1.1 项目目标

开发一款功能丰富的 Android 占卜应用，提供多种占卜方式（塔罗牌为主、辅以占星、灵数、抽签、Oracle 占卜卡），支持英语、他加禄语（Tagalog）和中文三种语言，完全离线运行，数据本地存储。

### 1.2 核心关键词

| 项目 | 说明 |
|------|------|
| **项目名 (已确认)** | `MysticaTarot` |
| **Dart 包名** | `mystica_tarot` |
| **Android 包名** | `com.mystica.tarot` |
| **语言** | 英语、他加禄语、中文（简体） |
| **中文应用名** | 神秘塔罗 |
| **商业模式** | 完全免费，无广告、无内购 |
| **网络需求** | 完全离线运行 |
| **最低 Android** | API 26 (Android 8.0 Oreo) |
| **目标 Android** | API 35 (Android 15) |

### 1.3 目标用户

- 占卜爱好者（初学者 & 进阶）
- 对塔罗牌感兴趣的使用者
- 英语 / 他加禄语 / 中文用户群体

---

## 2. 技术栈

### 2.1 核心技术

| 技术 | 版本/方案 | 说明 |
|------|-----------|------|
| **框架** | Flutter 3.x+ (最新稳定版) | — |
| **语言** | Dart 3.x+ | 使用空安全、Pattern Matching |
| **状态管理** | Provider | 适合中大型项目，简洁成熟 |
| **本地数据库** | Hive | 轻量级 NoSQL，极速读写 |
| **本地通知** | `flutter_local_notifications` | 实现每日抽卡提醒 |
| **音效播放** | `audioplayers` | 播放翻牌、洗牌音效 |
| **分析工具** | `flutter_analyze` | 遵循 Dart Lint 规则 |
| **测试** | `flutter_test` + `mocktail` | Unit Test + Widget Test |

### 2.2 开发工具

| 工具 | 用途 |
|------|------|
| **Flutter SDK** | 主框架 |
| **VS Code / Android Studio** | IDE |
| **Git + GitHub** | 版本控制 |
| **Flutter DevTools** | 性能分析 |
| **Android SDK** | Android 构建 |

### 2.3 Pub 依赖（初步）

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.0              # 状态管理
  hive: ^2.2.3                   # 本地数据库
  hive_flutter: ^1.1.0           # Hive Flutter 支持
  flutter_local_notifications: ^17.0.0  # 本地通知
  audioplayers: ^6.0.0           # 音效播放
  intl: ^0.19.0                  # 国际化
  flutter_localizations:
    sdk: flutter                 # Flutter 原生本地化支持
  share_plus: ^9.0.0             # 分享占卜结果（可选）

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1         # Hive 类型适配器生成
  build_runner: ^2.4.0           # 代码生成
  mocktail: ^1.0.0               # Mock 测试
  flutter_lints: ^4.0.0          # Lint 规则
```

---

## 3. 项目架构

### 3.1 架构模式：Feature-First + MVVM

遵循 skills 中推荐的 **Feature-First 架构**，核心原则：

```
UI (Widgets) → ViewModel (Provider) → Service → Hive DataSource
```

- **UI 层**: 纯声明式 Widget，只负责渲染和事件转发
- **ViewModel (Provider)**: 管理 UI 状态，处理交互逻辑
- **Service 层**: 业务逻辑（占卜算法、读取解读内容等）
- **Data 层**: Hive 数据存取、JSON 内容资源

### 3.2 依赖方向

```dart
// 正确的依赖方向
UI Widget → ChangeNotifier → TarotService → HiveRepository
                    ↕
            LocalizationService
```

- 各层通过抽象接口解耦（Service 接口）
- Provider 作为依赖注入容器

### 3.3 目录结构

```
lib/
├── main.dart                          # 应用入口
├── app.dart                           # MaterialApp 配置
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart         # 全局常量
│   │   ├── card_constants.dart        # 塔罗牌常量数据
│   │   └── divination_constants.dart  # 占卜常量
│   ├── theme/
│   │   ├── app_theme.dart             # 主题配置
│   │   ├── app_colors.dart            # 调色板
│   │   └── app_text_styles.dart       # 字体样式
│   ├── localization/
│   │   ├── app_localizations.dart     # 本地化主类
│   │   ├── app_localizations_en.dart  # 英文
│   │   ├── app_localizations_tl.dart  # 他加禄语
│   │   ├── app_localizations_zh.dart  # 中文
│   │   └── supported_locales.dart     # 支持的语言配置
│   ├── router/
│   │   └── app_router.dart            # 路由配置
│   └── utils/
│       ├── date_utils.dart            # 日期工具
│       ├── random_utils.dart          # 随机种子工具
│       └── sound_utils.dart           # 音效工具类
│
├── features/
│   ├── onboarding/                    # 新手引导
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── onboarding_page.dart
│   │   │   └── widgets/
│   │   │       └── onboarding_item.dart
│   │   └── providers/
│   │       └── onboarding_provider.dart
│   │
│   ├── home/                          # 主页
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── home_page.dart
│   │   │   └── widgets/
│   │   │       ├── divination_card.dart       # 占卜方式卡片
│   │   │       └── daily_card_widget.dart      # 每日抽卡组件
│   │   ├── providers/
│   │   │   └── home_provider.dart
│   │   └── services/
│   │       └── daily_card_service.dart
│   │
│   ├── tarot/                         # 塔罗牌模块
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   ├── tarot_home_page.dart        # 塔罗牌主界面
│   │   │   │   ├── spread_selection_page.dart  # 选择牌阵
│   │   │   │   ├── card_draw_page.dart         # 抽牌动画页面
│   │   │   │   └── reading_result_page.dart    # 解读结果
│   │   │   └── widgets/
│   │   │       ├── tarot_card_widget.dart      # 单张塔罗牌组件
│   │   │       ├── card_back_widget.dart       # 牌背设计
│   │   │       ├── spread_layout_widget.dart   # 牌阵布局
│   │   │       ├── card_flip_animation.dart    # 翻牌动画
│   │   │       ├── shuffle_animation.dart      # 洗牌动画
│   │   │       └── reading_detail_card.dart    # 解读详情卡片
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── tarot_card.dart             # 塔罗牌实体
│   │   │   │   ├── spread.dart                 # 牌阵实体
│   │   │   │   └── reading.dart                # 占卜记录实体
│   │   │   └── repositories/
│   │   │       └── tarot_repository.dart        # 存储接口
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── tarot_card_data.dart        # 塔罗牌数据模型
│   │   │   ├── repositories/
│   │   │   │   └── tarot_repository_impl.dart   # 存储实现
│   │   │   ├── datasources/
│   │   │   │   └── tarot_card_content.dart      # 塔罗牌内容数据
│   │   │   └── json/
│   │   │       ├── major_arcana.json            # 大阿卡纳内容
│   │   │       └── minor_arcana.json            # 小阿卡纳内容
│   │   ├── services/
│   │   │   ├── tarot_reading_service.dart       # 占卜逻辑
│   │   │   └── spread_service.dart              # 牌阵布局逻辑
│   │   └── providers/
│   │       ├── tarot_provider.dart              # 塔罗牌状态管理
│   │       └── reading_history_provider.dart    # 历史记录管理
│   │
│   ├── astrology/                     # 占星/星座模块
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── astrology_page.dart
│   │   │   └── widgets/
│   │   │       └── zodiac_card.dart
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── zodiac_sign.dart
│   │   ├── data/
│   │   │   └── json/
│   │   │       └── zodiac_content.json
│   │   ├── services/
│   │   │   └── astrology_service.dart
│   │   └── providers/
│   │       └── astrology_provider.dart
│   │
│   ├── numerology/                    # 灵数学模块
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── numerology_page.dart
│   │   │   └── widgets/
│   │   │       └── number_chart.dart
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── life_path_number.dart
│   │   ├── services/
│   │   │   └── numerology_service.dart
│   │   └── providers/
│   │       └── numerology_provider.dart
│   │
│   ├── fortune_slip/                  # 幸运签模块
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── fortune_slip_page.dart
│   │   │   └── widgets/
│   │   │       └── fortune_slip_widget.dart
│   │   ├── data/
│   │   │   └── json/
│   │   │       └── fortune_slips.json
│   │   ├── services/
│   │   │   └── fortune_slip_service.dart
│   │   └── providers/
│   │       └── fortune_slip_provider.dart
│   │
│   ├── oracle_cards/                  # Oracle 占卜卡模块
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── oracle_cards_page.dart
│   │   │   └── widgets/
│   │   │       └── oracle_card_widget.dart
│   │   ├── data/
│   │   │   └── json/
│   │   │       └── oracle_cards_content.json
│   │   ├── services/
│   │   │   └── oracle_reading_service.dart
│   │   └── providers/
│   │       └── oracle_provider.dart
│   │
│   ├── daily_card/                    # 每日抽卡
│   │   ├── presentation/
│   │   │   └── pages/
│   │   │       └── daily_card_page.dart
│   │   ├── services/
│   │   │   └── daily_card_service.dart
│   │   └── providers/
│   │       └── daily_card_provider.dart
│   │
│   └── history/                       # 历史记录
│       ├── presentation/
│       │   ├── pages/
│       │   │   └── history_page.dart
│       │   └── widgets/
│       │       ├── history_card.dart
│       │       └── reading_detail_page.dart
│       └── providers/
│           └── history_provider.dart
│
├── shared/
│   ├── widgets/
│   │   ├── app_scaffold.dart          # 通用页面框架
│   │   ├── mystical_button.dart       # 风格化按钮
│   │   ├── mystical_card.dart         # 风格化卡片
│   │   ├── gradient_background.dart   # 渐变背景
│   │   ├── particle_effect.dart       # 粒子特效
│   │   ├── shimmer_loading.dart       # 加载骨架屏
│   │   ├── language_selector.dart     # 语言选择组件
│   │   └── settings_tile.dart         # 设置页面组件
│   └── extensions/
│       ├── context_extensions.dart
│       └── string_extensions.dart
│
├── settings/                          # 设置模块
│   ├── presentation/
│   │   └── pages/
│   │       ├── settings_page.dart
│   │       └── about_page.dart
│   └── providers/
│       └── settings_provider.dart
│
docs/                              # 项目文档 & 日志
├── development-log.md           # 开发阶段日志（每个Phase完成时追加）
├── bug-log.md                  # Bug/问题追踪日志
└── decision-log.md             # 关键决策记录（架构变更、技术选型理由）

└── assets/
    ├── images/
    │   ├── cards/                     # 塔罗牌图片
    │   │   ├── major/                 # 大阿卡纳
    │   │   └── minor/                 # 小阿卡纳
    │   ├── backgrounds/               # 背景图片
    │   ├── icons/                     # 图标
    │   └── onboarding/                # 引导页图片
    ├── sounds/
    │   ├── shuffle.mp3                # 洗牌声
    │   ├── flip.mp3                   # 翻牌声
    │   ├── fan.mp3                    # 扇牌声
    │   └── reveal.mp3                 # 揭示音效
    └── fonts/                         # 自定义字体
```

---

## 4. 功能规格

### 4.1 功能总览

| # | 功能模块 | 优先级 | 说明 |
|---|----------|--------|------|
| 1 | 新手引导 | P1 | 首次启动 3-5 页引导，可跳过 |
| 2 | 主界面 | P1 | 展示所有占卜方式入口 + 每日抽卡 |
| 3 | 塔罗牌占卜 | P1 | 核心功能，全 78 张牌 |
| 4 | 每日抽卡 | P1 | 每天固定一张（日期种子），本地通知提醒 |
| 5 | 占星/星座 | P1 | 根据生日查看星座运势 |
| 6 | 灵数学 | P1 | 根据生日/姓名计算生命路径数 |
| 7 | 幸运签 | P2 | 电子抽签 |
| 8 | Oracle 占卜卡 | P2 | 指引卡系统 |
| 9 | 历史记录 | P1 | 保存每次占卜结果 |
| 10 | 设置 | P1 | 语言切换、通知开关、音效开关 |
| 11 | 结果分享 | P2 | 分享占卜结果到社交平台 |

### 4.2 占卜方式详解

#### 4.2.1 塔罗牌占卜 (Tarot)

**牌组**: 全 78 张（22 张大阿卡纳 + 56 张小阿卡纳 · 四花色）

**小阿卡纳花色**:
| 花色 | 元素 | 中文 |
|------|------|------|
| Wands | Fire | 权杖 |
| Cups | Water | 圣杯 |
| Swords | Air | 宝剑 |
| Pentacles | Earth | 星币 |

**支持牌阵 (6种)**:

| 牌阵 | 牌数 | 说明 |
|------|------|------|
| 单张牌 | 1 | 快速指引，每日运势 |
| 三张牌 | 3 | 过去-现在-未来 |
| 凯尔特十字 | 10 | 经典深度解读 |
| 关系牌阵 | 5-7 | 感情关系分析 |
| 愿望牌阵 | 4 | 目标达成路径 |
| 四季牌阵 | 4 | 季度运势 |

**解读内容结构**（每张牌需包含）:
- 牌名（多语言）
- 关键词（2-3个）
- 正位含义 (Upright Meaning)
- 逆位含义 (Reversed Meaning)
- 爱情解读 (Love)
- 事业/财富解读 (Career/Finance)
- 建议 (Advice)

**抽牌流程**:
1. 选择牌阵 → 确认
2. 洗牌动画（模拟真实洗牌，约 3-5 秒）
3. 切牌动画（用户可选择切牌位置）
4. 逐张翻牌（每张约 1 秒动画）
5. 展示解读结果

**注意**: 每日抽卡功能使用日期作为随机种子，保证同一用户同一天抽到同一张牌（固定每日一卡）。

#### 4.2.2 占星/星座 (Astrology)

**功能要点**:
- 用户选择/输入出生日期
- 显示对应的星座（12星座）
- 展示每日/每周/每月星座运势
- 星座特质分析（性格、幸运色、幸运数字等）

**12星座列表**:
| 英文 | 中文 | Tagalog |
|------|------|---------|
| Aries | 白羊座 | Aries |
| Taurus | 金牛座 | Taurus |
| Gemini | 双子座 | Gemini |
| Cancer | 巨蟹座 | Cancer |
| Leo | 狮子座 | Leo |
| Virgo | 处女座 | Virgo |
| Libra | 天秤座 | Libra |
| Scorpio | 天蝎座 | Scorpio |
| Sagittarius | 射手座 | Sagittarius |
| Capricorn | 摩羯座 | Capricorn |
| Aquarius | 水瓶座 | Aquarius |
| Pisces | 双鱼座 | Pisces |

> **注意**: 每日运势可复用每日抽卡的种子逻辑，实现每天不同但固定。

#### 4.2.3 灵数学 (Numerology)

**计算方式**:
- **生命路径数 (Life Path Number)**: 出生日期数字相加至个位数
- **命运数 (Destiny Number)**: 姓名字母对应数字相加至个位数

**数字解读** (1-9 + 主数 11, 22, 33):
| 数字 | 含义 |
|------|------|
| 1 | 领导者、独立、创新 |
| 2 | 合作、平衡、外交 |
| 3 | 创造力、表达、社交 |
| 4 | 稳定、务实、勤奋 |
| 5 | 自由、冒险、变化 |
| 6 | 责任、关爱、家庭 |
| 7 | 内省、智慧、灵性 |
| 8 | 权力、成功、物质 |
| 9 | 人道、奉献、完成 |
| 11 | 直觉、灵感、导师（主数） |
| 22 | 大师建造者（主数） |
| 33 | 大师教师（主数） |

#### 4.2.4 幸运签 (Fortune Slip)

**功能要点**:
- 模拟传统寺庙/神社的抽签
- 点击抽取 → 摇签动画 → 显示签文
- 签文分为：大吉、中吉、小吉、吉、末吉、凶
- 每次抽取随机

#### 4.2.5 Oracle 占卜卡 (Oracle Cards)

**功能要点**:
- 与塔罗类似但更自由
- 预设 40-50 张指引卡
- 支持单张、三张抽牌
- 每张卡包含正能量指引语

### 4.3 每日抽卡

**机制**:
- 基于日期生成固定随机种子 → 每日唯一结果
- 用户每天首次打开 APP 时弹出或显示在主界面
- 可通过本地通知在设定时间提醒用户
- 每日结果保存至历史记录

**数据模型**:
```
DailyCardRecord {
  date: String (YYYY-MM-DD)
  cardType: enum (tarot / oracle)
  cardIndex: int
  position: upright / reversed
  readingText: String
  timestamp: DateTime
}
```

### 4.4 历史记录

**功能**:
- 按日期排序的历史记录列表
- 每条记录显示：占卜类型、日期、摘要（牌的图标/名称）
- 点击可查看完整占卜详情
- 支持单条删除
- 支持清空所有记录

**存储方案**: Hive Box

### 4.5 设置

**可配置项**:
| 设置项 | 默认值 | 说明 |
|--------|--------|------|
| 语言 | English | en / tl / zh |
| 每日通知开启 | true | 本地推送通知 |
| 通知时间 | 09:00 | 每日提醒时间 |
| 音效开启 | true | 操作音效开关 |
| 历史记录上限 | 500 | 自动清理旧记录 |
| 牌背图案选择 | 默认 | 多种牌背可选 |
| 主题 | 玫瑰粉 | 调色板主题 |

---

## 5. 页面与导航

### 5.1 页面流

```
Onboarding (首次启动)
  │
  ▼
HomePage (主界面)
  ├── TarotHomePage
  │     ├── SpreadSelectionPage
  │     │     └── CardDrawPage (动画)
  │     │           └── ReadingResultPage
  │     └── ReadingHistoryPage
  ├── AstrologyPage
  │     └── ZodiacDetailPage
  ├── NumerologyPage
  │     └── NumberDetailPage
  ├── FortuneSlipPage
  ├── OracleCardsPage
  │     └── OracleResultPage
  ├── DailyCardPage
  ├── HistoryPage
  │     └── ReadingDetailPage (复用)
  └── SettingsPage
        └── AboutPage
```

### 5.2 页面设计要点

| 页面 | 关键元素 |
|------|----------|
| **Onboarding** | 3-5 页横向滑动，底部圆点指示器+跳过+下一步按钮，梦幻背景 |
| **HomePage** | 顶部: 每日抽卡小卡片（若有今日结果直接显示）; 中部: 5 个占卜方式入口（带图标和文字的大卡片网格布局）; 底部: 底部导航栏(Home / History / Settings) |
| **TarotHomePage** | 顶部横幅: 塔罗主题装饰; 牌阵选择网格; 底部"开始占卜"按钮 |
| **CardDrawPage** | 中央展示牌阵布局; 逐张点击翻牌; 粒子特效环绕; 背景音乐/音效 |
| **ReadingResultPage** | 展示所有已翻牌; 点击单张牌展开详情（正逆位、关键词、含义、建议）; 分享、保存按钮 |
| **AstrologyPage** | 顶部: 星座选择器（横向滑动）; 中部: 选中星座详情（日期、性格、幸运色等）; 下方: 星座运势分段（今日/本周/本月） |
| **NumerologyPage** | 输入出生日期/姓名的表单; 计算按钮; 结果展示: 数字+详细解读 |
| **FortuneSlipPage** | 中央签筒动画; 摇动手机/点击抽签; 显示签文+评级 |
| **OracleCardsPage** | 类似塔罗简约版; 单张/三张模式选择 |
| **HistoryPage** | 时间线式列表; 按月份分组; 每项显示摘要 |
| **SettingsPage** | 列表式: 语言、通知、音效、关于等 |

---

## 6. 数据模型

### 6.1 塔罗牌 (TarotCard)

```dart
@HiveType(typeId: 0)
class TarotCard {
  final int id;                    // 唯一ID (0-77)
  final CardType type;             // major / minor
  final String nameEn;             // 英文名: "The Fool"
  final String nameZh;             // 中文名: "愚人"
  final String nameTl;             // Tagalog名
  final int number;                // 编号 (大阿卡纳0-21, 小阿卡纳1-14)
  final Suit? suit;                // 花色 (小阿卡纳)
  final List<String> keywordsEn;   // 英文关键词
  final List<String> keywordsZh;   // 中文关键词
  final List<String> keywordsTl;   // Tagalog关键词
  final String meaningUprightEn;   // 正位解读(英)
  final String meaningUprightZh;   // 正位解读(中)
  final String meaningUprightTl;   // 正位解读(TL)
  final String meaningReversedEn;  // 逆位解读(英)
  final String meaningReversedZh;  // 逆位解读(中)
  final String meaningReversedTl;  // 逆位解读(TL)
  final String loveEn;             // 爱情解读
  final String loveZh;
  final String loveTl;
  final String careerEn;           // 事业解读
  final String careerZh;
  final String careerTl;
  final String adviceEn;           // 建议
  final String adviceZh;
  final String adviceTl;
}
```

### 6.2 牌阵 (Spread)

```dart
class Spread {
  final String id;                 // "single", "three", "celtic_cross"...
  final String nameEn;
  final String nameZh;
  final String nameTl;
  final int cardCount;
  final List<SpreadPosition> positions; // 每个位置的含义
}

class SpreadPosition {
  final int index;
  final String nameEn;             // "Past", "Present", "Future"
  final String nameZh;
  final String nameTl;
  final String descriptionEn;
  final String descriptionZh;
  final String descriptionTl;
}
```

### 6.3 占卜记录 (ReadingRecord)

```dart
@HiveType(typeId: 1)
class ReadingRecord {
  final String id;                 // UUID
  final DateTime timestamp;
  final DivinationType type;       // tarot / astrology / numerology / fortune_slip / oracle
  final String? spreadId;          // 牌阵ID (仅塔罗)
  final List<CardResult> cards;    // 抽牌结果
  final String? userInput;         // 用户输入 (姓名/生日等)
  final String? notes;             // 用户备注
}

@HiveType(typeId: 2)
class CardResult {
  final int cardIndex;             // 牌索引
  final bool isReversed;           // 是否逆位
  final int position;              // 在牌阵中的位置
}
```

### 6.4 设置 (AppSettings)

```dart
@HiveType(typeId: 3)
class AppSettings {
  final String locale;             // "en" / "tl" / "zh"
  final bool dailyNotification;
  final String notificationTime;   // "HH:mm"
  final bool soundEnabled;
  final int maxHistoryCount;
  final String cardBackStyle;
  final String themeColor;
}
```

---

## 7. UI/UX 设计

### 7.1 设计风格：梦幻魔法风 (Dreamy Magical)

**核心视觉元素**:
- 主色调: **玫瑰粉** (#E8A0B4 / #D4A5A5 / 暖粉色系)
- 辅助色: 柔和紫 (#C9B1D0)、月夜蓝 (#A8C5DA)、金色 (#E8C87A)
- 背景: 柔和渐变（粉→紫→蓝）
- 装饰: 星星、月亮、花瓣、魔法光晕、微光粒子
- 字体: 圆润优雅字体（英文 + 中文手写体）
- 卡片: 圆角大、微阴影、轻微浮起效果
- 牌背: 梦幻花纹 + 星星月亮图案
- 图标: 线条柔和、带轻微渐变

### 7.2 Material Design 3

```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFE8A0B4),  // 玫瑰粉
    brightness: Brightness.light,
  ),
  // 自定义圆角、字体等
)
```

### 7.3 动画与交互

| 交互相 | 动画效果 | 时长 |
|--------|----------|------|
| 翻牌 | 3D 旋转翻转（从牌背到牌面） | 800ms |
| 洗牌 | 牌堆快速交错移动 + 模糊效果 | 3-5s |
| 切牌 | 牌堆分为两叠移动 | 1.5s |
| 抽签摇动 | 签筒抖动 + 签条飞出 | 2s |
| 牌阵展示 | 牌逐张从中央飞入指定位置 | 300ms/张 |
| 粒子特效 | 星星/花瓣飘落 | 持续 |
| 页面切换 | 柔和渐变动画 | 300ms |
| 按钮点击 | 缩放 + 涟漪 | 150ms |

### 7.4 声音设计

| 操作 | 音效类型 |
|------|----------|
| 洗牌 | 快速连续的纸牌摩擦声 |
| 切牌 | 单次纸牌滑动声 |
| 翻牌 | 清脆的纸牌翻转声 |
| 揭示结果 | 柔和的"叮"或和弦音 |
| 抽签 | 签筒摇晃的竹签声 |
| 按钮点击 | 轻柔的点击声 |
| 背景音乐 | 轻柔冥想风格（可循环、音量低） |

### 7.5 字体

| 语言 | 推荐字体 | 说明 |
|------|----------|------|
| 英文 | **Playfair Display** | 优雅衬线体，神秘感，英文字体 |
| 中文 | **Noto Serif SC** (思源宋体) | 优雅中文字体，与 Playfair Display 风格协调 |
| Tagalog | **Playfair Display** (共用英文) | 他加禄语使用拉丁字母，与英文共用同一字体 |

### 7.6 启动闪屏页 (Splash Screen)

**策略**: 使用原生 Android SplashScreen API（Android 12+ 适配）+ Flutter 自定义闪屏

**闪屏内容**:
- 展示 APP 图标（神秘塔罗牌图案）+ 应用名 **神秘塔罗 / MysticaTarot**
- 柔和渐入渐出动画，约 2 秒
- 首次启动 → 新手引导；非首次 → 主界面

**实现方式**:
- Android 12+: `android.os.Build.VERSION.SDK_INT >= 31` 使用原生 `SplashScreen` API
- 低版本 Android: 使用 Flutter 自定义 Splash Screen widget
- 依赖: `flutter_native_splash` 包辅助配置

### 7.7 深色模式支持

**支持策略**: 提供 **浅色 + 深色** 两套完整主题，用户可手动切换或跟随系统。

**深色主题调整**:
| 元素 | 浅色 | 深色 |
|------|------|------|
| 背景 | 粉→紫→蓝渐变 | 深紫→深蓝渐变 (#1A1025 → #0D1B2A) |
| 卡片 | 白色半透明 | 深灰紫半透明 (#2D1B3E) |
| 文字 | 深色 | 浅粉/金色 (#E8C87A) |
| 牌面 | 亮色调 | 柔和暗色调 |
| 粒子特效 | 粉色/金色 | 银白/淡紫 |

### 7.8 响应式布局

由于仅针对 Android 手机，主要适配:
- 手机竖屏为主（Portrait）
- 宽度在 360-480dp 的屏幕
- 最小触摸区域 48x48dp
- 支持无障碍（大字体模式）

---

## 8. 本地化 (i18n)

### 8.1 支持语言

| 语言 | 代码 | 显示名称 |
|------|------|----------|
| English | `en` | English |
| Tagalog | `tl` | Tagalog / Filipino |
| 简体中文 | `zh` | 简体中文 (应用名: 神秘塔罗) |

### 8.2 用户切换方式

- APP 内提供语言切换开关（Settings 页面）
- `setLocale()` 方法改变 Provider 中的语言状态
- 所有文本实时切换，无需重启 APP
- 使用 `flutter_localizations` + 自定义 `AppLocalizations`

### 8.3 本地化内容范围

| 内容类型 | 本地化方式 | 说明 |
|----------|------------|------|
| UI 文本 | ARB 文件或 Dart Map | 按钮、标签、提示等 |
| 塔罗牌含义 | JSON 数据（三语字段） | 每张牌正逆位 + 各维度解读 |
| 占星数据 | JSON 数据 | 星座名称、性格描述等 |
| 灵数解读 | JSON 数据 | 数字含义描述 |
| 幸运签文 | JSON 数据 | 三语签文 |
| Oracle 卡 | JSON 数据 | 三语指引 |
| 新手引导 | Dart 常量 | 引导文案 |
| 错误提示 | ARB / Map | 错误信息 |

### 8.4 翻译策略

```
第一阶段: 英文内容全部写完整
第二阶段: 中文翻译（可由开发者或译者补充）
第三阶段: Tagalog翻译（可由开发者或译者补充）
```

> 初始发布版本可先支持英文 + 中文，Tagalog 后续版本更新补充。

---

## 9. 本地存储方案

### 9.1 Hive 数据库设计

| Box 名称 | 类型 | 用途 |
|----------|------|------|
| `reading_history` | `List<ReadingRecord>` | 占卜历史记录 |
| `daily_card` | `Map<String, DailyCardRecord>` | 每日抽卡缓存 |
| `settings` | `AppSettings` | 用户设置 |
| `favorites` | `List<String>` | 收藏的占卜记录ID |

### 9.2 数据初始化

- 首次启动: 将 JSON 内容（塔罗牌数据、星座数据等）加载到内存
- JSON 文件存储在 `assets/data/` 目录
- 无需在 Hive 中存储占卜内容（内容读取自 assets）

### 9.3 数据清理

- 历史记录超过 `maxHistoryCount`（默认 500）时，自动删除最旧的记录
- 用户可手动清除所有历史记录
- 每日抽卡缓存每日自动更新

---

## 10. Git 工作流

### 10.1 分支策略：精简 Git Flow

```
main          ← 稳定发布版本
└── develop   ← 日常开发
    ├── feature/tarot-core
    ├── feature/astrology
    ├── feature/numerology
    ├── feature/history
    ├── feature/localization
    ├── feature/animations
    ├── fix/card-flip-bug
    └── ...
```

### 10.2 Commit 规范

遵循 **Conventional Commits** 格式：

```
<type>(<scope>): <简短描述>

示例:
feat(tarot): 实现塔罗牌洗牌动画
feat(localization): 添加英文+中文本地化支持
fix(reading): 修复历史记录时间显示错误
refactor(provider): 重构为 Provider 状态管理
docs: 添加 README 和开发文档
style: 格式化代码
test(tarot): 添加塔罗牌模型单元测试
chore: 更新依赖版本
```

### 10.3 文件 .gitignore

```gitignore
/build/
.dart_tool/
.packages
.pub/
.pub-cache/
.flutter-plugins*
.flutter-plugins-dependencies
*.iml
.idea/
.vscode/
*.lock
# 注意: 不忽略 docs/*.log，因为开发日志和Bug日志需要被版本追踪
# *.log
android/local.properties
android/key.properties
ios/Pods/
ios/.symlinks/
coverage/
```

### 10.4 GitHub 仓库配置

#### 10.4.1 仓库信息

| 项目 | 值 |
|------|------|
| **GitHub 用户名** | `yx368491-cpu` |
| **仓库名称** | `MysticaTarot` |
| **远程 URL (HTTPS)** | `https://github.com/yx368491-cpu/MysticaTarot.git` |
| **默认分支** | `main` |
| **许可证** | MIT License（推荐） |

#### 10.4.2 HTTPS + Token 连接方式

由于使用 **HTTPS + Personal Access Token** 进行认证，需要完成以下配置：

**Step 1: 创建 Personal Access Token（在 GitHub 网页端）**

1. 登录 GitHub → 右上角头像 → **Settings**
2. 左侧导航 → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
3. 点击 **Generate new token** → **Generate new token (classic)**
4. 设置 token 名称：`MysticaTarot`
5. 过期时间：建议 **No expiration** 或 **90 days**
6. 勾选权限（scopes）：
   - ✅ `repo`（完整控制仓库）
   - ✅ `workflow`（如需 GitHub Actions）
7. 点击 **Generate token**，**立即复制保存**生成的 token（关闭页面后无法再次查看）

**Step 2: 在本地配置 Git 凭据**

```bash
# 配置 Git 全局用户信息（首次使用 Git 时需要）
git config --global user.name "yx368491-cpu"
git config --global user.email "你的邮箱@example.com"

# 方法一：使用 Git 凭据管理器（推荐，只需输入一次密码/token）
git config --global credential.helper manager
# 之后首次 push 时会弹出窗口输入用户名和 token（注意：密码框里填 token 不是 GitHub 密码）

# 方法二：在远程 URL 中嵌入 token（不推荐，token 会明文存储在 .git/config 中）
# git remote set-url origin https://yx368491-cpu:你的TOKEN@github.com/yx368491-cpu/MysticaTarot.git
```

**Step 3: 首次推送到 GitHub 的完整流程**

```bash
# 1. 在项目根目录初始化 Git
git init

# 2. 添加所有文件到暂存区
git add .

# 3. 首次提交
git commit -m "chore: 初始化 MysticaTarot 项目"

# 4. 重命名默认分支为 main
git branch -M main

# 5. 添加远程仓库
git remote add origin https://github.com/yx368491-cpu/MysticaTarot.git

# 6. 推送到 GitHub（首次需要先在 GitHub 创建空仓库）
git push -u origin main
```

> **⚠️ 重要提示**: 在运行 `git push` 之前，请先在 GitHub 网页端创建名为 `MysticaTarot` 的空仓库（不要勾选 "Add a README"，因为本地已有）。

#### 10.4.3 远程仓库创建清单

在 GitHub.com 上创建新仓库时，请确保：
- [ ] 仓库名: `MysticaTarot`
- [ ] 描述: "MysticaTarot — 占卜塔罗牌 Android APP，支持英语 / 他加禄语 / 中文"
- [ ] Public 或 Private（由你决定）
- [ ] ❌ 不要勾选 "Initialize this repository with a README"
- [ ] ❌ 不要勾选 "Add .gitignore"（本地方已配置）
- [ ] ❌ 不要勾选 "Choose a license"（本地方已准备）

#### 10.4.4 GitHub 后续维护命令速查

```bash
# 查看当前仓库远程配置
git remote -v

# 创建功能分支
git checkout -b feature/tarot-core

# 推送功能分支到远程
git push -u origin feature/tarot-core

# 合并到 develop 分支
git checkout develop
git merge feature/tarot-core

# 打标签（发布版本）
git tag v0.2.0
git push origin v0.2.0

# 查看提交历史
git log --oneline --graph --all
```

### 10.5 版本号规范

遵循语义化版本 (Semantic Versioning):

| 版本 | 说明 |
|------|------|
| v0.1.0 | 初始原型 |
| v0.2.0 | 塔罗核心功能完成 |
| v0.3.0 | 所有占卜方式完成 |
| v0.4.0 | 本地化 + 设置完成 |
| v1.0.0 | 正式发布 |

---

## 11. 开发路线图

### Phase 1: 项目初始化 (Day 1-3)

- [ ] 创建 Flutter 项目 (`flutter create --org com.mystica mystica_tarot`)
- [ ] 配置 `pubspec.yaml` 依赖
- [ ] 建立项目目录结构（含 `docs/` 日志目录、`assets/` 资源目录）
- [ ] 创建 `README.md`（项目简介、功能、技术栈、截图占位）
- [ ] 选择并添加许可证文件 `LICENSE`（推荐 MIT）
- [ ] 配置主题系统（玫瑰粉色系，Material 3）
- [ ] 配置 Hive 数据库（初始化代码、Box 注册）
- [ ] 配置本地化框架（`AppLocalizations` 骨架）
- [ ] 配置 `analysis_options.yaml`（Dart Lint 规则）
- [ ] 初始化 Git 仓库：`git init && git add . && git commit -m "chore: init"`
- [ ] 登录 GitHub 创建远程仓库 `MysticaTarot`（见 10.4.3 清单）
- [ ] 配置 Personal Access Token 并连接远程仓库
- [ ] 推送到 GitHub：`git push -u origin main`
- [ ] 创建 `develop` 分支并推送：`git checkout -b develop && git push -u origin develop`
- [ ] 验证 GitHub 仓库连接是否正常（`git remote -v`、`git fetch`）
- [ ] 🪵 **生成 Phase 1 开发日志** — 记录项目搭建过程中的决策（包名确认、依赖版本选择、GitHub 配置过程）

### Phase 2: 塔罗核心 (Day 4-12)

- [ ] 导入塔罗牌 78 张牌数据（从公开经典内容整理）
- [ ] 实现塔罗牌数据模型
- [ ] 实现牌阵模型（6种牌阵）
- [ ] 开发塔罗主界面（选择牌阵）
- [ ] 开发抽牌页面 + 翻牌动画
- [ ] 开发解读结果展示页面
- [ ] 实现洗牌/翻牌音效
- [ ] 实现粒子特效（仪式感）
- [ ] 🪵 **生成 Phase 2 开发日志** — 记录塔罗核心功能的实现细节、动画技术方案、遇到的关键 bug（并在 `bug-log.md` 中记录）

### Phase 3: 其他占卜方式 (Day 13-18)

- [ ] 占星/星座功能
- [ ] 灵数学功能
- [ ] 幸运签功能
- [ ] Oracle 占卜卡功能
- [ ] 🪵 **生成 Phase 3 开发日志** — 记录各占卜方式的数据结构设计、算法实现、遇到的 i18n 问题及解决方案

### Phase 4: 每日抽卡 & 历史记录 (Day 19-22)

- [ ] 每日抽卡逻辑（日期种子）
- [ ] 本地通知提醒
- [ ] 历史记录存储与展示
- [ ] 详情页复用
- [ ] 🪵 **生成 Phase 4 开发日志** — 记录本地通知实现方案、Hive 数据迁移策略（如有）、日期种子算法的注意事项

### Phase 5: 引导 & 设置 & 本地化 (Day 23-27)

- [ ] 新手引导页面（3-5页）
- [ ] 设置页面（语言、通知、音效等）
- [ ] 英文 UI 文本
- [ ] 中文 UI 文本
- [ ] Tagalog UI 文本
- [ ] 塔罗牌解读内容本地化
- [ ] 🪵 **生成 Phase 5 开发日志** — 记录本地化框架搭建细节、翻译管理策略、三语文本中的特殊字符/排版问题

### Phase 6: 测试 & 优化 (Day 28-32)

- [ ] 单元测试（数据模型、服务逻辑）
- [ ] Widget 测试（关键页面）
- [ ] 性能优化（Profiling）
- [ ] 无障碍测试
- [ ] 多语言测试
- [ ] 多机型兼容性测试
- [ ] 🪵 **生成 Phase 6 开发日志** — 记录测试覆盖率、发现的性能瓶颈、兼容性问题 & 对应修复方案（同步更新 `bug-log.md`）

### Phase 7: 发布 (Day 33-35)

- [ ] 生成签名密钥 (Keystore)
- [ ] 配置签名
- [ ] 构建 Release APK / AAB
- [ ] 准备应用截图和描述
- [ ] Google Play 发布准备
- [ ] 🪵 **生成 Phase 7 开发日志** — 记录打包过程中的坑（签名问题、ProGuard 混淆规则、权限声明等）& 发布 checklist
- [ ] 📊 **回顾与总结** — 浏览整个 `bug-log.md`，总结高频错误模式，完善开发规范

---

## 12. 项目建议名称

基于"梦幻魔法风"的设计方向，推荐以下 GitHub 项目名：

| 项目名 | 可用性 | 含义 |
|--------|--------|------|
| **MysticaTarot** | ★★★★★ | 拉丁语源"Mystica"(神秘) + Tarot，简短易记 |
| **TarotMystica** | ★★★★ | 同上，语序不同 |
| **DreamDivine** | ★★★★ | 梦幻 + 神圣占卜 |
| **LunaTarot** | ★★★★ | Luna(月亮)象征神秘和直觉 |
| **MysticOracle** | ★★★ | 神秘预言者，涵盖所有占卜方式 |
| **PinkTarot** | ★★★ | 简单直接，反映粉色主题 |
| **RoseDivination** | ★★★ | 玫瑰 + 占卜，柔美梦幻 |

> **推荐首选**: `MysticaTarot` — 简短、优雅、易记，涵盖神秘感与塔罗核心。

---

## 13. 日志与问题追踪系统

### 13.1 开发阶段日志 (Development Log)

**文件**: `docs/development-log.md`

**用途**: 每个开发阶段完成后，在此文件中追加一条详细日志，记录该阶段的完成情况、关键决策、技术要点，方便未来维护者（包括未来的自己）了解项目演进历史。

**日志格式**:

```markdown
# MysticaTarot 开发日志

---

## Phase [编号]: [阶段名称]

**完成日期**: YYYY-MM-DD  
**耗时**: X 天  
**Git Tag**: v0.x.0  

### 完成的功能
- [功能1]: 简要描述
- [功能2]: 简要描述

### 关键技术决策
- **决策**: [如"使用 Provider + ChangeNotifier 管理状态"]
  **理由**: 项目规模适中，Provider 的 boilerplate 比 Bloc 少，开发效率更高

### 文件结构变化
- 新增: `lib/features/tarot/...`
- 修改: `lib/core/theme/app_theme.dart`

### 遗留问题/TODO
- [ ] 牌阵布局在 360dp 以下屏幕显示溢出
- [ ] 翻牌动画在低端设备略卡

### 注意事项（给未来自己/协作者）
- Hive 初始化必须在 runApp 之前完成，否则会导致 `TypeError`
- 塔罗牌图片资源使用了 RWS 开源重绘版，作者: [作者名]，已在 about_page 中标注

### 参考资源
- Flutter 动画文档: https://docs.flutter.dev/ui/animations
- xx 插件的 issue #123 解决了 xx 问题

---

## Phase [编号]: [阶段名称]
...
```

**规范要求**:
1. 每个 Phase 完成、合并到 `develop` 分支后必须追加日志
2. 在创建对应的 Git Tag 时同步更新日志
3. 如果 Phase 内有多次 iterations（如修复 bug），在日志末尾的「注意事项」中注明
4. 遇到无法在当前 Phase 解决的遗留问题，必须记录到「遗留问题/TODO」

---

### 13.2 Bug/问题日志 (Bug Log)

**文件**: `docs/bug-log.md`

**用途**: 记录开发过程中遇到的所有 Bug、坑、陷阱及解决方案，形成知识库，避免重复踩坑。

**日志格式**:

```markdown
# MysticaTarot Bug & 踩坑日志

---

## Bug #[递增编号]: [简短标题]

**发现日期**: YYYY-MM-DD  
**发现阶段**: Phase X - [阶段名称]  
**严重程度**: 🔴 严重 / 🟡 中等 / 🟢 轻微  
**状态**: ✅ 已修复 / 🔄 修复中 / 📌 待处理  

### 现象描述
发生了什么问题？（崩溃、UI 异常、逻辑错误等）

### 复现步骤
1. 进入 XXX 页面
2. 点击 XXX 按钮
3. 观察 XXX 现象

### 根因分析
为什么会出现这个问题？
- 根本原因: xxx
- 涉及文件: `lib/xxx/xxx.dart` 第 XX 行

### 解决方案
如何修复的？提供代码片段或思路

```dart
// 修复前
Widget build(BuildContext context) { ... }

// 修复后
Widget build(BuildContext context) { ... }
```

### 教训/预防措施
如何避免类似问题再次发生？
- 在 code review 时注意检查 xxx
- 建议为 xxx 添加单元测试
- 查阅官方文档确认 xxx 的正确用法

### 相关链接
- Flutter Issue #12345
- StackOverflow 回答: https://...
- PR 链接: https://github.com/...

---

## Bug #2: ...
```

**规范要求**:
1. Bug 编号从 001 开始递增
2. 发现即记录，即使还没修复也要记录
3. 修复后更新状态并补充解决方案
4. 每个 Bug 尽可能关联到具体的文件路径和行号
5. 定期回顾（如每两个月），总结高频错误模式

---

### 13.3 关键决策日志 (Decision Log)

**文件**: `docs/decision-log.md`

**用途**: 记录架构变更、技术选型、第三方库选择等关键决策及其理由，帮助理解"为什么这么做"。

**日志格式**:

```markdown
# MysticaTarot 关键决策日志

---

## Decision #[递增编号]: [决策标题]

**日期**: YYYY-MM-DD  
**决策者**: [姓名]  

### 背景
为什么要做这个决策？面临什么问题？

### 可选方案
| 方案 | 优点 | 缺点 |
|------|------|------|
| 方案 A | ... | ... |
| 方案 B | ... | ... |

### 最终选择
选择了方案 A。

### 理由
1. ...
2. ...

### 影响范围
- 涉及模块: ...
- 需要修改的文件: ...

### 后续验证
- [ ] 在 Phase X 验证此决策的合理性
- [ ] 如果没有达到预期，考虑切换到方案 B

---
```

---

### 13.4 日志维护规范总览

| 日志类型 | 文件 | 触发时机 | 责任人 |
|----------|------|----------|--------|
| **开发阶段日志** | `docs/development-log.md` | 每个 Phase 完成时 | 开发者 |
| **Bug 日志** | `docs/bug-log.md` | Bug 发现时立即记录 | 发现者 |
| **决策日志** | `docs/decision-log.md` | 关键决策做出时 | 决策者 |

#### 日志文件的 Git 策略
- **所有日志文件必须纳入版本控制**（`.gitignore` 中不忽略 `docs/`）
- 日志在开发阶段实时更新，随代码一起 commit
- Commit message 示例: `docs: 追加 Phase 2 开发日志` / `docs: 记录 Bug #004 及修复方案`

#### 日志文件模板（初始创建时）

**`docs/development-log.md` 初始内容**:
```markdown
# MysticaTarot 开发日志

> 项目: MysticaTarot — 占卜塔罗牌 Android APP
> 起始日期: YYYY-MM-DD
> 此文件记录每个开发阶段的完成情况、关键决策与注意事项。

---
```

**`docs/bug-log.md` 初始内容**:
```markdown
# MysticaTarot Bug & 踩坑日志

> 项目: MysticaTarot — 占卜塔罗牌 Android APP
> 此文件记录开发过程中遇到的所有 Bug、陷阱及解决方案。

---
```

**`docs/decision-log.md` 初始内容**:
```markdown
# MysticaTarot 关键决策日志

> 项目: MysticaTarot — 占卜塔罗牌 Android APP
> 此文件记录架构变更、技术选型等关键决策及其理由。

---
```

---

## 附录

### A1. 已确认的决策汇总

| 决策项 | 确认结果 |
|--------|----------|
| 项目名称 | **MysticaTarot** |
| 中文应用名 | **神秘塔罗** |
| Android 包名 | `com.mystica.tarot` |
| Dart 包名 | `mystica_tarot` |
| 开发 IDE | **VS Code** |
| 中文版本 | **简体中文** (`zh`) |
| 英文字体 | **Playfair Display** (衬线体) |
| 中文字体 | **Noto Serif SC** (思源宋体) |
| 塔罗牌图片 | **RWS 开源重绘版**（需标注作者） |
| APP 图标 | **神秘塔罗牌**图案 |
| 启动闪屏 | **需要**（原生 API + Flutter 自定义） |
| 深色模式 | **支持**（浅色+深色两套主题） |
| Tagalog 星座 | **直接使用英文名** |
| 状态管理 | **Provider** |
| 本地存储 | **Hive** |
| GitHub 用户名 | **yx368491-cpu** |
| GitHub 认证方式 | **HTTPS + Personal Access Token** |
| 最低 Android | **API 26 (Android 8.0)** |
| 通知 | **flutter_local_notifications** |
| 音效 | **audioplayers** |

### A2. 塔罗牌内容来源建议

塔罗牌解读内容可使用以下公开领域资源为基础：

1. **Rider-Waite Tarot 经典释义** — 1920 年以前的经典解读属于公共领域
2. **The Pictorial Key to the Tarot** (A.E. Waite) — 公开领域作品
3. **The Tarot of the Bohemians** (Papus) — 公开领域作品

> 建议以 Rider-Waite 系统的经典释义为骨架，改编为更现代、易懂的语言。

### A3. 图像资源

**已确认方案**: 使用 RWS 开源重绘版塔罗牌图片

- 所有 78 张塔罗牌图片打包到 `assets/images/cards/`
- 图片格式: WebP（推荐，减小约 30% 体积）或 PNG
- 分辨率: 建议 300×520 px 左右（适配手机屏幕）
- 需在 `about_page` 中注明图片来源和作者信息
- 牌背图案单独设计（梦幻花纹+星星月亮）

### A4. 音效资源

- 可使用 Freesound.org 的 CC0 音效
- 或使用专业音效包
- 建议使用 `audioplayers` 包播放本地音效文件（wav / mp3）

### A5. APP 图标设计方向

**风格**: 神秘塔罗牌图案
- 选取一张代表性塔罗牌作为主元素（如「月亮」牌或「女皇」牌）
- 玫瑰粉 + 金色渐变背景
- 圆角方形图标（自适应 Android Adaptive Icon）
- 前景: 塔罗牌图案（白色/金色线条风格）
- 背景: 玫瑰粉到柔和紫的渐变

### A6. 开发者环境配置

| 工具 | 配置 |
|------|------|
| **IDE** | VS Code + Flutter 扩展 + Dart 扩展 |
| **SDK** | Flutter SDK 最新稳定版 + Android SDK API 35 |
| **Git** | Git + GitHub 账户 |
| **Android 模拟器** | Android Studio Emulator (Pixel 6 API 35) |
| **命令行工具** | PowerShell (Windows) / 终端

---

> **本文档将在开发过程中持续更新。所有重大决策应记录在此文档中。**
