# 🔮 MysticaTarot (神秘塔罗)

> Android 占卜塔罗牌 APP — 支持英语 / 他加禄语 / 中文

**MysticaTarot** 是一款功能丰富的离线 Android 占卜应用，提供塔罗牌 (Tarot)、占星 (Astrology)、灵数学 (Numerology)、幸运签 (Fortune Slip) 和 Oracle 指引卡等多种占卜方式。所有功能完全离线运行，数据本地存储，保护您的隐私。

## ✨ 功能特色

- 🃏 **塔罗牌占卜** — 完整 78 张 Rider-Waite 塔罗牌，支持 6 种牌阵
- ⭐ **占星/星座** — 12 星座每日/每周/每月运势
- 🔢 **灵数学** — 生命路径数 & 命运数计算与解读
- 🎋 **幸运签** — 模拟传统抽签，多种签文等级
- 🎴 **Oracle 指引卡** — 心灵指引与正能量启示
- 📅 **每日抽卡** — 每日自动生成一张专属塔罗牌
- 📜 **历史记录** — 保存所有占卜结果，随时回顾
- 🌙 **深色模式** — 浅色/深色主题切换
- 🌍 **多语言** — English / Tagalog / 简体中文

## 🛠 技术栈

| 技术 | 方案 |
|------|------|
| 框架 | Flutter 3.x |
| 语言 | Dart 3.x (空安全) |
| 状态管理 | Provider |
| 本地存储 | Hive |
| 本地通知 | flutter_local_notifications |
| 音效 | audioplayers |
| 国际化 | flutter_localizations + intl |

## 📱 最低支持

- **Android**: API 26 (Android 8.0 Oreo)
- **目标**: API 35 (Android 15)

## 🚀 开始使用

```bash
# 克隆项目
git clone https://github.com/yx368491-cpu/MysticaTarot.git

# 安装依赖
cd MysticaTarot
flutter pub get

# 运行
flutter run
```

## 📂 项目结构

```
lib/
├── core/           # 核心基础设施 (主题、常量、本地化、路由、工具)
├── features/       # 功能模块 (Feature-First 架构)
├── shared/         # 共享组件 (Widgets、Extensions)
└── settings/       # 设置模块
docs/               # 开发日志、Bug 日志、决策日志
assets/             # 图片、音效、字体资源
```

## 📄 许可证

本项目基于 MIT 许可证开源。详见 [LICENSE](LICENSE) 文件。

## ⚠️ 免责声明

本应用仅供娱乐参考。塔罗占卜结果不能替代专业建议。
