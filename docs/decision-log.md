# MysticaTarot 关键决策日志

> 项目: MysticaTarot — 占卜塔罗牌 Android APP
> 此文件记录架构变更、技术选型等关键决策及其理由。

---

## Decision #1: RWS 塔罗牌图片来源选型

**日期**: 2026-06-23  
**决策者**: AI Agent  

### 背景
需要为 78 张塔罗牌选择开源、高质量的图片来源。

### 可选方案
| 方案 | 优点 | 缺点 |
|------|------|------|
| Wikimedia Commons Geldard 版 | 命名统一、色彩还原好、Public Domain | 需逐个下载，有 API 速率限制 |
| Wikipedia 标准版 | 可免费使用 | 画质参差不齐，命名不一致 |
| 自行生成 SVG | 完全自定义 | 工作量大，缺乏专业度 |

### 最终选择
选择了 Wikimedia Commons (Geldard) 版。

### 理由
1. 78 张卡片的命名格式完全统一：`[Card Name] (Rider-Waite Smith tarot deck).png`
2. Public Domain 无需额外授权
3. 色彩经过数字修复，质量较好

### 影响范围
- 所有塔罗牌功能页面的图片引用路径
- 命名需从 Commons 格式转换为 `Ace_of_Wands.png` 格式

---

## Decision #2: 字体渲染策略

**日期**: 2026-06-23  
**决策者**: AI Agent  

### 背景
需要使用 Playfair Display（英/Tagalog）和 Noto Serif SC（中文）两种字体。

### 可选方案
| 方案 | 优点 | 缺点 |
|------|------|------|
| 可变字体（Variable Font） | 单个文件包含所有字重，减小 APK | 文件体积仍较大（Noto SC 11MB） |
| 静态字体文件（TTF） | 可按需选择字重 | 多个文件管理复杂 |
| Google Fonts 动态加载 | 不增加 APK 体积 | 需要网络，违反离线要求 |

### 最终选择
使用可变字体。

### 理由
1. Playfair Display 可变字体仅 300KB，包含 Regular~Bold 所有字重
2. Noto Serif SC 黑度轴可变字体 11MB，稍大但可接受
3. 完全离线运行，不依赖网络加载

---

## Decision #3: JSON 数据本地路径

**日期**: 2026-06-23  
**决策者**: AI Agent  

### 背景
塔罗牌内容、占星数据等需要存储在项目中并加载到内存。

### 可选方案
| 方案 | 优点 | 缺点 |
|------|------|------|
| JSON 文件 + AssetBundle 加载 | 数据与代码分离、易于替换 | 需异步加载 |
| Dart const Map 硬编码 | 编译时即用，无需加载 | 文件巨大，难以维护 |
| Hive Box 预填充 | 查询方便 | 首次启动需预填充 |

### 最终选择
JSON 文件通过 AssetBundle 加载，运行时解析到内存 Model。

### 理由
1. 数据与代码分离，方便后续多语言内容更新
2. JSON 结构清晰，可直接映射到 Dart Model
3. AssetBundle 加载是 Flutter 标准做法

---
