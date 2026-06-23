# Codebuff Skills 安装方案 Spec

> 创建日期：2026-06-22
> 项目路径：`E:\APP`
> 项目类型：Flutter Android 应用
> 当前状态：空项目（尚未初始化）

---

## 1. 背景与目标

用户希望在 `E:\APP` 项目目录中安装社区可用的 Codebuff skills，以辅助开发一个 Flutter Android 应用。项目目录当前为空，skills 安装优先于 Flutter 项目初始化。

**核心需求：**
- 从社区/网上下载并安装现成的 skills
- 安装范围为 **project-specific**（项目级）
- 安装在 `E:\APP\.agents\skills\` 目录下
- 按文件夹分类组织 skills
- 优先考虑具体技能 > 通用技能
- 一次性安装全面、丰富的 skills

---

## 2. 技术前提条件

### 2.1 Windows 环境问题

当前系统为 Windows（win32），未检测到 bash 环境。Codebuff CLI 依赖 bash 运行。

**需要完成的前置步骤：**

| 方案 | 说明 | 推荐度 |
|------|------|--------|
| **Git for Windows (Git Bash)** | 安装 Git for Windows，自带 Git Bash | ⭐⭐⭐ 推荐 |
| **WSL (Windows Subsystem for Linux)** | 安装 WSL2 + Linux 发行版 | ⭐⭐ 功能最全但较重 |
| **设置 CODEBUFF_GIT_BASH_PATH** | 如有自定义 bash.exe 路径，设置环境变量 | ⭐ 已有 Git Bash 时使用 |

### 2.2 Codebuff CLI 确认

- 确认 `codebuff` CLI 已安装（通过 npm 全局安装或 npx 使用）
- 确认版本为最新版本

### 2.3 Flutter SDK

虽然 skills 安装不依赖 Flutter SDK，但后续创建 Android 应用需要：
- 安装 Flutter SDK
- 配置 Android Studio 及相关工具链
- 此处不在本 spec 范围内，仅作提醒

---

## 3. Skills 目录结构设计

```
E:\APP\
├── .agents\
│   └── skills\
│       ├── flutter\                    # Flutter 核心开发技能
│       │   ├── SKILL.md
│       │   └── (可选子 skill 或 README)
│       ├── flutter-android\            # Flutter Android 专项
│       │   └── SKILL.md
│       ├── flutter-testing\           # Flutter 测试策略
│       │   └── SKILL.md
│       ├── flutter-architecture\      # Flutter 项目架构
│       │   └── SKILL.md
│       ├── flutter-ui-ux\             # Flutter UI/UX 设计
│       │   └── SKILL.md
│       ├── flutter-network\           # Flutter 网络与存储
│       │   └── SKILL.md
│       ├── git-workflow\              # Git 版本控制工作流
│       │   └── SKILL.md
│       ├── code-review\               # 代码审查最佳实践
│       │   └── SKILL.md
│       └── dart-language\             # Dart 语言最佳实践
│           └── SKILL.md
```

### 3.1 Skills 命名规范

- 全部小写字母、数字和连字符
- 无连续连字符
- 文件夹名称必须与 YAML frontmatter 中的 `name` 字段完全一致

---

## 4. Skills 清单与内容规划

### 4.1 Flutter 核心开发 (`flutter`)

**用途：** Flutter 项目开发的核心实践——widget 构建、状态管理、路由、生命周期等。

**建议来源：**
- [Codebuff 社区](https://github.com/topics/codebuff-skill)
- 参考 [codebuff.com/docs/tips/skills](https://www.codebuff.com/docs/tips/skills) 官方指南编写

**YAML 头部：**
```yaml
---
name: flutter
description: Flutter 核心开发最佳实践：Widget 构建、状态管理、路由、动画基础
metadata:
  category: mobile
  priority: high
---
```

### 4.2 Flutter Android 专项 (`flutter-android`)

**用途：** Android 平台特有的配置、权限、打包、发布等最佳实践。

**YAML 头部：**
```yaml
---
name: flutter-android
description: Flutter Android 平台专项：AndroidManifest 配置、权限、打包 APK/AAB、Google Play 发布
metadata:
  category: mobile
  priority: high
---
```

### 4.3 Flutter 测试策略 (`flutter-testing`)

**用途：** Unit test、Widget test、Integration test 的编写规范和最佳实践。

**YAML 头部：**
```yaml
---
name: flutter-testing
description: Flutter 测试策略：Unit Test、Widget Test、Integration Test 编写规范
metadata:
  category: testing
  priority: medium
---
```

### 4.4 Flutter 项目架构 (`flutter-architecture`)

**用途：** 项目结构组织、依赖注入、Clean Architecture 等架构模式。

**YAML 头部：**
```yaml
---
name: flutter-architecture
description: Flutter 项目架构：Clean Architecture、依赖注入、模块化设计
metadata:
  category: architecture
  priority: medium
---
```

### 4.5 Flutter UI/UX (`flutter-ui-ux`)

**用途：** UI 组件设计、响应式布局、主题系统、Material Design 3 适配。

**YAML 头部：**
```yaml
---
name: flutter-ui-ux
description: Flutter UI/UX：Material Design 3、响应式布局、主题系统、动画交互
metadata:
  category: ui
  priority: medium
---
```

### 4.6 Flutter 网络与存储 (`flutter-network`)

**用途：** HTTP 请求、REST API 集成、本地存储、JSON 序列化、错误处理。

**YAML 头部：**
```yaml
---
name: flutter-network
description: Flutter 网络通信与数据持久化：HTTP、REST API、本地存储、错误处理
metadata:
  category: data
  priority: medium
---
```

### 4.7 Git 工作流 (`git-workflow`)

**用途：** Git 分支策略、commit 规范、代码合并、版本发布流程。

**YAML 头部：**
```yaml
---
name: git-workflow
description: Git 工作流：分支管理、Commit 规范、Code Review、版本发布
metadata:
  category: devops
  priority: low
---
```

### 4.8 代码审查 (`code-review`)

**用途：** 代码审查的检查清单和最佳实践，确保代码质量。

**YAML 头部：**
```yaml
---
name: code-review
description: 代码审查检查清单与最佳实践：性能、安全、可维护性
metadata:
  category: quality
  priority: low
---
```

### 4.9 Dart 语言 (`dart-language`)

**用途：** Dart 语言特性、类型系统、异步编程、空安全等最佳实践。

**YAML 头部：**
```yaml
---
name: dart-language
description: Dart 语言最佳实践：类型系统、空安全、异步编程、Lint 规则
metadata:
  category: language
  priority: medium
---
```

---

## 5. Skills 优先级规则

依据用户选择的 **"具体优先于通用"** 策略：

| 优先级 | Skills |
|--------|--------|
| 🥇 **高** | `flutter`、`flutter-android` |
| 🥈 **中** | `flutter-testing`、`flutter-architecture`、`flutter-ui-ux`、`flutter-network`、`dart-language` |
| 🥉 **低** | `git-workflow`、`code-review` |

**冲突处理方式：** 当多个 skills 对同一任务有不同指导时，更具体的 skill（如 `flutter-android`）优先级高于通用 skill（如 `flutter`）。

---

## 6. 安装步骤计划

```
Step 1: 确保环境就绪（配置 Git Bash / WSL）
Step 2: 安装/验证 Codebuff CLI（npm install -g codebuff 或 npx codebuff）
Step 3: 创建目录结构 mkdir -p .agents/skills/{flutter,...}
Step 4: 编写各个 SKILL.md 文件（含 YAML frontmatter + 内容）
Step 5: 验证安装（启动 Codebuff CLI，检查 /skill: 命令能否列出所有 skills）
Step 6: 初始化 Flutter 项目（flutter create .）
```

---

## 7. 验证方案

- 启动 Codebuff，输入 `/skill:` 查看所有已加载的 skills 列表
- 输入 `/skill:flutter` 确认对应 skill 能被加载
- 检查目录结构是否正确
- 确认 YAML frontmatter 的 `name` 与文件夹名称一致

---

## 8. 未解决的问题 / 待办

- [ ] 寻找具体的社区 skill 仓库来源（GitHub 搜索 codebuff-skill 等标签）
- [ ] 确认用户是否已安装 Git for Windows 或 WSL
- [ ] 确认 Codebuff CLI 是否已全局安装
- [ ] Flutter SDK 安装（后续步骤）
- [ ] Android Studio 配置（后续步骤）

---

*本 spec 文件由 Codebuff AI 根据用户访谈生成。*
